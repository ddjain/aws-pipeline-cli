# AWS Pipeline CLI

A simple interactive CLI tool to view and trigger AWS CodePipeline executions from your terminal.

## Installation (Mac & Ubuntu)

1. **Clone this repository:**

```bash
git clone https://github.com/yourusername/aws-pipeline-cli.git
cd aws-pipeline-cli
```

2. **(Optional) Make the script executable:**

```bash
chmod +x aws-pipeline-cli.sh
```

3. **(Optional) Add to your PATH:**

You can copy or symlink the script to a directory in your PATH, e.g.:

```bash
sudo cp aws-pipeline-cli.sh /usr/local/bin/aws-pipeline-cli
```

Or run it directly from the cloned directory:

```bash
./aws-pipeline-cli.sh
```

## Prerequisites

- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) must be installed and configured (`aws configure`).
- [jq](https://stedolan.github.io/jq/) must be installed for JSON parsing.

Install on Mac (with Homebrew):
```bash
brew install awscli jq
```

Install on Ubuntu:
```bash
sudo apt update
sudo apt install awscli jq
```

## Usage

```bash
./aws-pipeline-cli.sh [profile] [columns]
```

- `profile` (optional): AWS CLI profile to use (default: default profile)
- `columns` (optional): Number of columns in the grid (default: 2)

### Example

```bash
./aws-pipeline-cli.sh my-aws-profile 3
```

## Features
- Interactive terminal UI to select and trigger pipelines
- Search and filter pipelines

## Uninstall

If you copied the script to `/usr/local/bin`:
```bash
sudo rm /usr/local/bin/aws-pipeline-cli
```

---

**Note:** This project is not affiliated with AWS. Use at your own risk. 
