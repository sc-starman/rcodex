# rcodex

Lightweight multi-profile manager for OpenAI Codex CLI.

`rcodex` allows you to maintain multiple isolated Codex environments on a single machine without logging in and out repeatedly.

Each profile gets its own:

* Authentication
* Configuration
* Sessions
* Chat History
* MCP Configuration
* Local Settings

Perfect for developers managing multiple OpenAI accounts, client environments, work/personal setups, or separate AI agents.

---

## Features

* Multiple Codex profiles
* Complete profile isolation
* Simple Unix-style CLI
* No external dependencies
* Pure Bash implementation
* Safe account separation
* Supports running multiple Codex instances simultaneously

---

## Installation

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/<username>/rcodex/main/install.sh | bash
```

---

## Quick Start

### Create a Profile

```bash
rcodex login personal
```

This creates:

```text
~/.rcodex/personal
```

and starts the normal Codex login flow.

---

### Launch a Profile

```bash
rcodex personal
```

---

### Create Multiple Profiles

```bash
rcodex login personal
rcodex login work
rcodex login client1
```

Launch any profile:

```bash
rcodex personal
rcodex work
rcodex client1
```

---

## Commands

### Login

Create or login to a profile.

```bash
rcodex login <profile>
```

Example:

```bash
rcodex login work
```

---

### Launch Codex

Start Codex using a profile.

```bash
rcodex <profile>
```

Example:

```bash
rcodex personal
```

---

### List Profiles

```bash
rcodex list
```

Example output:

```text
Profiles:

✓ personal
✓ work
✓ client1
```

---

### Profile Status

```bash
rcodex status <profile>
```

Example:

```bash
rcodex status work
```

Output:

```text
Profile : work
Path    : /home/user/.rcodex/work
Login   : Yes
Size    : 42M
```

---

### Rename Profile

```bash
rcodex rename <old> <new>
```

Example:

```bash
rcodex rename client1 customerA
```

---

### Remove Profile

```bash
rcodex remove <profile>
```

Example:

```bash
rcodex remove customerA
```

The command asks for confirmation before deleting.

---

## Directory Structure

Profiles are stored under:

```text
~/.rcodex/
```

Example:

```text
~/.rcodex/
├── personal/
├── work/
├── customerA/
└── production/
```

Each directory is a fully isolated Codex environment.

---

## How It Works

When launching a profile:

```bash
rcodex personal
```

`rcodex` automatically sets:

```bash
CODEX_HOME=~/.rcodex/personal
```

before starting Codex.

This ensures complete separation between:

* Authentication Tokens
* Config Files
* Sessions
* MCP Servers
* Chat History
* Local State

No profile can affect another profile.

---

## Running Multiple Accounts Simultaneously

You can run multiple Codex instances at the same time:

Terminal 1:

```bash
rcodex personal
```

Terminal 2:

```bash
rcodex work
```

Terminal 3:

```bash
rcodex customerA
```

Each instance uses its own authentication and configuration.

---

## File Structure

Repository layout:

```text
rcodex/
├── README.md
├── LICENSE
├── install.sh
├── rcodex
└── .gitignore
```

### rcodex

Main executable script.

### install.sh

Installer script that:

* Downloads rcodex
* Installs into ~/bin
* Makes executable
* Adds ~/bin to PATH if needed

### LICENSE

MIT License.

---

## Requirements

* Linux
* Bash
* OpenAI Codex CLI

---

## Example Workflow

Create profiles:

```bash
rcodex login personal
rcodex login work
```

List profiles:

```bash
rcodex list
```

Launch work profile:

```bash
rcodex work
```

Check profile information:

```bash
rcodex status work
```

Rename profile:

```bash
rcodex rename work company
```

Remove profile:

```bash
rcodex remove company
```

---

## Why rcodex?

Codex CLI currently stores all state in a single `CODEX_HOME` directory.

`rcodex` provides a lightweight solution for:

* Multiple OpenAI accounts
* Client environments
* Work vs Personal separation
* Agent-specific configurations
* Isolated MCP environments

without requiring logouts, file copying, or manual environment management.

---

## License

MIT License.

Feel free to use, modify, and distribute.

---

## Repository Description

Lightweight multi-profile manager for OpenAI Codex CLI. Run multiple Codex accounts and isolated environments from a single machine.

---

## Suggested GitHub Topics

```text
codex
openai
codex-cli
cli
bash
developer-tools
productivity
mcp
openai-codex
terminal
linux
```
