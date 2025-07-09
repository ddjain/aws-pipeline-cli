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
chmod +x aws-pipeline-cli.sh
sudo cp aws-pipeline-cli.sh /usr/local/bin/aws-pipeline-cli
```

### 2. One-liner (install script)
```sh
curl -fsSL https://raw.githubusercontent.com/ddjain/aws-pipeline-cli/refs/tags/v1.0.2/aws-pipeline-cli.sh -o /usr/local/bin/aws-pipeline-cli
sudo chmod +x /usr/local/bin/aws-pipeline-cli
```

---

## Uninstall

```sh
sudo rm /usr/local/bin/aws-pipeline-cli
```
---

## Usage

aws-codepipeline-cli [--profile <profile>] [columns]

* `--profile <profile>` : AWS CLI profile to use (optional, default: default profile)
* `columns` : Number of columns in the grid (optional, default: 2)
* `--help` : Show help message
* `--version`: Show version
* `update`: Update to the latest version

### Example

aws-codepipeline-cli
aws-codepipeline-cli --profile myprofile 3
aws-codepipeline-cli --help
aws-codepipeline-cli update

---

## Arguments

| Argument           | Description                                         |
|-------------------|-----------------------------------------------------|
| --profile <name>  | AWS CLI profile to use (optional)                   |
| columns           | Number of columns in the grid (optional)            |
| --help            | Show help message and exit                          |
| --version         | Show version information and exit                   |
| update            | Update to the latest version and exit               |

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

---


## Alternative: Manual/One-liner Install

Until your Homebrew tap is set up, users can still install manually or with the one-liner as described in your README:

```sh
curl -fsSL https://raw.githubusercontent.com/ddjain/aws-pipeline-cli/refs/tags/v1.0.2/aws-pipeline-cli.sh -o /usr/local/bin/aws-pipeline-cli
sudo chmod +x /usr/local/bin/aws-pipeline-cli
```
