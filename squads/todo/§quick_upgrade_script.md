§quick_upgrade_script

## overview

a quick upgrade script for me to use

## user journey

user run `curl -fsSL https://raw.githubusercontent.com/neodejack/squads/main/upgrade.sh | bash` when they are in a repo that uses squads

then the script can download latest files from github main branch and overwrite them in the current repo
these are the latest stuff that should be downloaded and copied

- `squads.just`
- files inside `hacks/squads/`

it should let user know exactly what files will be added/overwritten and then prompt user for confirmation of proceeding

## tech spec

### implementation

Created `upgrade.sh` bash script with the following features:

**Core Functionality:**
- Downloads latest files from GitHub main branch:
  - `squads.just`
  - `hacks/squads/init.py`
  - `hacks/squads/todo.py`
- Shows clear preview of changes (new files vs. overwritten files)
- Prompts for user confirmation before making changes
- Preserves file permissions (makes .py files executable)
- Clean error handling with automatic cleanup

**Safety Features:**
- Validates that we're in a squads repo (checks for squads.just)
- Uses temporary directory for downloads (auto-cleaned up)
- Color-coded output for better UX
- Detailed error messages when downloads fail
- Option to cancel at confirmation prompt

**Requirements:**
- Repository must be public for curl downloads to work
- User must have curl installed
- Script must be run from root of squads repository

**Usage:**

Easiest way (via just command):
```bash
just squads upgrade
```

Or directly with curl:
```bash
curl -fsSL https://raw.githubusercontent.com/neodejack/squads/main/upgrade.sh | bash
```

Or run locally:
```bash
./upgrade.sh
```

**Note:** The repository needs to be public on GitHub for the curl command to work, or you need to push the upgrade.sh and other files to the main branch first.
