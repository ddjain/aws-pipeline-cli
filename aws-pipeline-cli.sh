#!/usr/bin/env bash

VERSION="v1.0.2"  # Update this on each release
github_repo="ddjain/aws-pipeline-cli"
script_path="/usr/local/bin/aws-codepipeline-cli"

# Self-update logic
check_for_update() {
    latest=$(curl -fsSL "https://api.github.com/repos/$github_repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [[ -z "$latest" ]]; then
        return
    fi
    if [[ "$latest" != "$VERSION" ]]; then
        echo "A new version ($latest) is available! You are running $VERSION."
        echo "Run 'aws-codepipeline-cli update' to upgrade."
    fi
}

self_update() {
    latest=$(curl -fsSL "https://api.github.com/repos/$github_repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [[ -z "$latest" ]]; then
        echo "Could not fetch latest version."
        exit 1
    fi
    echo "Updating to version $latest..."
    sudo curl -fsSL "https://raw.githubusercontent.com/$github_repo/refs/tags/$latest/aws-pipeline-cli.sh" -o "$script_path"
    sudo chmod +x "$script_path"
    echo "Update complete! Now running version $latest."
    exit 0
}

# Default values
PROFILE=""
COLUMNS=2

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --help)
            echo "Usage: aws-pipeline-cli [--profile <profile>] [columns]"
            echo "  --profile <profile>  AWS CLI profile to use (optional, default: default profile)"
            echo "  columns              Number of columns in the grid (optional, default: 2)"
            echo "  --help               Show this help message and exit"
            echo "  --version            Show version information and exit"
            echo "  update               Update to the latest version and exit"
            exit 0
            ;;
        --version)
            echo "aws-pipeline-cli version $VERSION"
            exit 0
            ;;
        update)
            self_update
            exit 0
            ;;
        [0-9]*)
            COLUMNS="$1"
            shift
            ;;
        *)
            # If not a recognized flag, treat as profile if not already set
            if [[ -z "$PROFILE" ]]; then
                PROFILE="$1"
            fi
            shift
            ;;
    esac
done

check_for_update

# Fetch list of CodePipelines
fetch_pipelines() {
    local output
    if [[ -n "$PROFILE" ]]; then
        output=$(aws codepipeline list-pipelines --profile "$PROFILE" --output text --query 'pipelines[*].name' 2>&1)
    else
        output=$(aws codepipeline list-pipelines --output text --query 'pipelines[*].name' 2>&1)
    fi
    if echo "$output" | grep -q "You must specify a region"; then
        echo "Error: AWS region not set. Please run 'aws configure' or set the AWS_REGION environment variable."
        exit 1
    fi
    if echo "$output" | grep -q "Unable to locate credentials"; then
        echo "Error: AWS credentials not found. Please run 'aws configure' or set the appropriate environment variables."
        exit 1
    fi
    if echo "$output" | grep -q "error"; then
        echo "AWS CLI error:"
        echo "$output"
        exit 1
    fi
    echo "$output" | tr '\t' '\n'
}

# Options (will be dynamically set)
options=()
while IFS= read -r line; do
    options+=("$line")
done < <(fetch_pipelines)
selected=0

# Disable echo and enable raw mode for arrow key reading
enable_raw_mode() {
    stty -echo -icanon time 0 min 0
}

disable_raw_mode() {
    stty sane
}

# Display menu
draw_menu() {
    clear
    echo "AWS CodePipelines (profile: $PROFILE)"
    echo "Use ↑ ↓ to navigate, press Enter to select, q to quit:"
    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            # Highlight selected option in green
            echo -e "> \033[32m${options[$i]}\033[0m"
        else
            echo "  ${options[$i]}"
        fi
    done
}

get_user_input() {
    while true; do
        draw_menu
        read -rsn1 key
        if [[ $key == $'q' ]]; then
            selected=-1
            break
        fi
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key2
            case "$key2" in
                "[A") # Up
                    ((selected--))
                    [[ $selected -lt 0 ]] && selected=$((${#options[@]} - 1))
                    ;;
                "[B") # Down
                    ((selected++))
                    [[ $selected -ge ${#options[@]} ]] && selected=0
                    ;;
            esac
        elif [[ $key == "" ]]; then
            break
        fi
    done
}

# Main loop
while true; do
    # Fetch pipelines and populate options
    options=()
    while IFS= read -r line; do
        options+=("$line")
    done < <(fetch_pipelines)
    if [[ ${#options[@]} -eq 0 ]]; then
        echo "No pipelines found for profile '$PROFILE'."
        exit 1
    fi
    selected=0
    search=""
    
    get_user_input_with_search() {
        local key
        while true; do
            # Filter options based on search
            filtered_options=()
            for opt in "${options[@]}"; do
                if [[ -z "$search" || "$opt" == *$search* ]]; then
                    filtered_options+=("$opt")
                fi
            done
            # Adjust selected if out of bounds
            [[ $selected -ge ${#filtered_options[@]} ]] && selected=0
            [[ $selected -lt 0 ]] && selected=0
            # Draw menu with search
            clear
            echo "|---------------------------------------------------------------------|"
            echo "|                        AWS Pipeline CLI                             |"
            echo "|---------------------------------------------------------------------|"
            if [[ -n "$PROFILE" ]]; then
                echo "AWS CodePipelines (profile: $PROFILE)"
            else
                echo "AWS CodePipelines (default profile)"
            fi
            echo "Type to search: $search"
            echo "Use ↑ ↓ ← → to navigate, Enter to select, :q to quit, Backspace to delete."
            # Print grid with aligned columns
            local total=${#filtered_options[@]}
            local rows=$(( (total + COLUMNS - 1) / COLUMNS ))
            # Calculate max width for each column
            local -a col_widths
            for ((col=0; col<COLUMNS; col++)); do
                col_widths[$col]=0
                for ((row=0; row<rows; row++)); do
                    idx=$((row + col * rows))
                    if [[ $idx -lt $total ]]; then
                        len=${#filtered_options[$idx]}
                        (( len > col_widths[$col] )) && col_widths[$col]=$len
                    fi
                done
            done
            for ((row=0; row<rows; row++)); do
                line=""
                for ((col=0; col<COLUMNS; col++)); do
                    idx=$((row + col * rows))
                    if [[ $idx -lt $total ]]; then
                        name="${filtered_options[$idx]}"
                        padlen=$((col_widths[$col] - ${#name}))
                        pad=""
                        for ((p=0; p<padlen; p++)); do pad+=" "; done
                        if [[ $idx -eq $selected ]]; then
                            line+=" > \033[32m${name}${pad}\033[0m  "
                        else
                            line+="   ${name}${pad}  "
                        fi
                    fi
                done
                echo -e "$line"
            done
            read -rsn1 key
            # Check for :q typed in search
            if [[ "$search" == ":q" ]]; then
                selected=-1
                break
            fi
            if [[ $key == $'q' ]]; then
                selected=-1
                break
            elif [[ $key == $'\x1b' ]]; then
                read -rsn2 key2
                case "$key2" in
                    "[A") # Up
                        # Move up a row
                        rowsz=$(( (total + COLUMNS - 1) / COLUMNS ))
                        if (( selected - 1 >= 0 )); then
                            selected=$(( selected - 1 ))
                        fi
                        ;;
                    "[B") # Down
                        # Move down a row
                        rowsz=$(( (total + COLUMNS - 1) / COLUMNS ))
                        if (( selected + 1 < total )); then
                            selected=$(( selected + 1 ))
                        fi
                        ;;
                    "[C") # Right
                        # Move right a column
                        rowsz=$(( (total + COLUMNS - 1) / COLUMNS ))
                        if (( selected + rowsz < total )); then
                            selected=$(( selected + rowsz ))
                        fi
                        ;;
                    "[D") # Left
                        # Move left a column
                        rowsz=$(( (total + COLUMNS - 1) / COLUMNS ))
                        if (( selected - rowsz >= 0 )); then
                            selected=$(( selected - rowsz ))
                        fi
                        ;;
                esac
            elif [[ $key == "" ]]; then
                break
            elif [[ $key == $'\x7f' ]]; then # Backspace
                search="${search%?}"
                selected=0
            else
                search+="$key"
                selected=0
            fi
        done
    }

    enable_raw_mode
    get_user_input_with_search
    disable_raw_mode

    # Use filtered_options and selected
    if [[ $selected -lt 0 ]]; then
        echo "Exiting..."
        break
    elif [[ ${#filtered_options[@]} -eq 0 ]]; then
        echo "No pipelines match your search."
        echo -e "\nPress any key to return to menu..."
        read -rsn1
        continue
    else
        PIPELINE_NAME="${filtered_options[$selected]}"
        while true; do
            read -p "Are you sure you want to run $PIPELINE_NAME? (y/N): " confirm
            case "$confirm" in
                [yY])
                    echo "Releasing pipeline: $PIPELINE_NAME..."
                    # Start pipeline execution
                    if [[ -n "$PROFILE" ]]; then
                        output=$(aws codepipeline start-pipeline-execution --name "$PIPELINE_NAME" --profile "$PROFILE" 2>&1)
                    else
                        output=$(aws codepipeline start-pipeline-execution --name "$PIPELINE_NAME" 2>&1)
                    fi
                    status=$?
                    if [[ $status -eq 0 ]]; then
                        execution_id=$(echo "$output" | grep 'pipelineExecutionId' | awk -F'\"' '{print $4}')
                        echo "Started execution. ID: $execution_id"
                    else
                        echo "Failed to start pipeline execution. AWS CLI output:"
                        echo "$output"
                    fi
                    echo -e "\nPress any key to return to menu..."
                    read -rsn1
                    break
                    ;;
                [nN]|"")
                    # Go back to menu
                    break
                    ;;
                *)
                    echo "Please answer y or n."
                    ;;
            esac
        done
    fi

done

