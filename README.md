# AWS CodePipeline CLI

An interactive terminal utility to view and trigger AWS CodePipeline pipelines with search and navigation features.

---

## Features
- List all AWS CodePipelines in your account
- Type-to-search and filter pipelines
- Grid view with arrow key navigation (up/down/left/right)
- Trigger (release) a pipeline with confirmation
- Supports custom AWS profiles and column layouts
- Clean, user-friendly terminal UI

---

## Installation

### 1. Manual
```sh
git clone https://github.com/ddjain/aws-pipeline-cli.git
cd aws-pipeline-cli
chmod +x aws-codepipeline-cli.sh
sudo cp aws-codepipeline-cli.sh /usr/local/bin/aws-codepipeline-cli
```

### 2. One-liner (install script)
```sh
curl -fsSL https://raw.githubusercontent.com/ddjain/aws-pipeline-cli/main/aws-codepipeline-cli.sh -o /usr/local/bin/aws-codepipeline-cli
sudo chmod +x /usr/local/bin/aws-codepipeline-cli
```

### 3. Homebrew (recommended for macOS/Linux)
```sh
brew tap ddjain/aws-pipeline-cli
brew install aws-codepipeline-cli
```

---

## Usage

```sh
aws-codepipeline-cli [profile] [columns]
```

- `profile`  : AWS CLI profile to use (optional, default: default profile)
- `columns`  : Number of columns in the grid (optional, default: 2)
- `--help`   : Show help message
- `--version`: Show version (1.0.0)

### Example
```sh
aws-codepipeline-cli
aws-codepipeline-cli myprofile 3
aws-codepipeline-cli --help
```

---

## Arguments
| Argument     | Description                                      |
|--------------|--------------------------------------------------|
| profile      | AWS CLI profile to use (optional)                |
| columns      | Number of columns in the grid (optional)         |
| --help       | Show help message and exit                       |
| --version    | Show version information and exit                |

---

## Requirements
- bash
- AWS CLI v2
- AWS credentials and region configured (`aws configure`)

---

## Screenshot
```
|---------------------------------------------------------------------|
|                        AWS CodePipeline CLI                         |
|---------------------------------------------------------------------|
AWS CodePipelines (profile: default)
Type to search: 
Use ↑ ↓ ← → to navigate, Enter to select, :q to quit, Backspace to delete.
 > my-pipeline-1      my-pipeline-2      my-pipeline-3
   ...
```

---

## License
MIT 