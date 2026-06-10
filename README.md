# rcodex

Lightweight multi-profile manager **and smart router** for OpenAI Codex CLI.

`rcodex` allows you to maintain multiple isolated Codex environments on a single machine without logging in and out repeatedly.

Each profile gets its own:

* Authentication
* Configuration
* Sessions
* Chat History
* MCP Configuration
* Local Settings

Perfect for developers managing multiple OpenAI accounts, client environments, work/personal setups, or separate AI agents.

On top of profile management, `rcodex` acts as a **router**: run it with no
arguments and it checks the live Codex rate limits of every logged-in
profile and automatically routes you to whichever account currently has the
most headroom. When one account gets close to its limit, `rcodex` quietly
starts steering you to the next-best one — no manual account juggling.

---

## Features

* Multiple Codex profiles
* Complete profile isolation
* **Smart routing to the best-available profile** based on live rate limits
* Simple Unix-style CLI
* No external dependencies
* Pure Bash implementation
* Safe account separation
* Supports running multiple Codex instances simultaneously
* Per-profile rate-limit caching for fast, repeated invocations

---

## Installation

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/sc-starman/rcodex/main/install.sh | bash
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

### Launch the Best Profile

Run with no arguments (or `best`) to automatically launch whichever
logged-in profile currently has the most rate-limit headroom:

```bash
rcodex
```

This is equivalent to:

```bash
rcodex best
```

`rcodex` checks each profile's 5-hour and weekly Codex rate limits (via
`codex app-server`) and picks the one with the most remaining headroom on
its most-constrained window. Results are cached per-profile for
`RCODEX_RATE_LIMIT_CACHE_TTL` seconds (default `120`) so repeated
invocations are instant.

`best` can also be used in place of a profile name elsewhere:

```bash
rcodex exec best "fix the failing tests"
rcodex status best
```

---

### Pass-Through to Codex

Anything that isn't a recognized rcodex subcommand or an existing profile
name is forwarded as-is to `codex` (or `codex exec`), using whichever
profile currently has the most rate-limit headroom. This means normal
`codex` flags, prompts, and subcommands work transparently through `rcodex`:

```bash
rcodex --help          # -> codex --help (best profile)
rcodex resume --last    # -> codex resume --last (best profile)
rcodex "fix the bug"    # -> codex "fix the bug" (best profile)
rcodex exec --help      # -> codex exec --help (best profile)
```

If a profile name is given, it's used directly and any remaining arguments
are passed straight through:

```bash
rcodex personal "fix the bug"   # -> codex "fix the bug" (personal profile)
```

---

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

### Run a Non-Interactive Command

Run `codex exec` using a profile.

```bash
rcodex exec <profile> [args...]
```

Example:

```bash
rcodex exec work "fix the failing tests"
```

---

### Rate Limit / Usage Status

Show the 5-hour and weekly Codex rate-limit usage for every profile:

```bash
rcodex limits
```

Example output:

```text
PROFILE            5H USED    5H LEFT  WEEK USED  WEEK LEFT
personal                1%        99%         0%       100%
work                   42%        58%        10%        90%
client1         (not logged in)
```

Cached values up to `RCODEX_RATE_LIMIT_CACHE_TTL` seconds old (default
`120`) may be shown. Pass `--refresh` to force a live check:

```bash
rcodex limits --refresh
```

This is the same data `rcodex` / `rcodex best` use to pick a profile.

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

Let `rcodex` pick whichever profile has the most rate-limit headroom:

```bash
rcodex
```

Check rate-limit usage across all profiles:

```bash
rcodex limits
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

On top of that, `rcodex` doubles as a **best-effort router** across your
accounts. Codex usage limits reset on rolling 5-hour and weekly windows —
if you juggle several accounts (e.g. multiple Plus/Pro plans), `rcodex`
saves you from manually checking `/status` in each one and switching by
hand. Just run `rcodex`, and it routes you to whichever profile has the
most rate-limit headroom right now.

---

## License

MIT License.

Feel free to use, modify, and distribute.

---

## Repository Description

Lightweight multi-profile manager and smart router for OpenAI Codex CLI. Run multiple Codex accounts and isolated environments from a single machine, and auto-route to whichever account has the most rate-limit headroom.

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
rate-limiting
router
```
