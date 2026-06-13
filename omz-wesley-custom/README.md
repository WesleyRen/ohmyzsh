# Wesley Oh My Zsh Customization

A thin customization layer on top of Oh My Zsh.

The goal is to keep Oh My Zsh as close to upstream as possible while maintaining personal preferences in custom files.

## Philosophy

```text
Upstream Oh My Zsh
        +
Wesley customizations
        =
Final environment
```

Do not modify upstream Oh My Zsh files.

Keep all personal changes under:

```text
$ZSH_CUSTOM
```

This allows Oh My Zsh to be updated without merge conflicts.

## Prerequisites

Install Oh My Zsh first:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install Homebrew if desired:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installation

```bash
chmod +x install-customized.sh
./install-customized.sh

source ~/.zprofile
source ~/.zshrc
```

## Files

Repository contents:

```text
install-customized.sh

wesley-zprofile
wesley-aliases.zsh
wesley-functions.zsh

wesley-robbyrussell.zsh-theme

README.md
```

Installed files:

```text
~/.zprofile

~/.oh-my-zsh/custom/wesley-aliases.zsh
~/.oh-my-zsh/custom/wesley-functions.zsh

~/.oh-my-zsh/custom/themes/wesley-robbyrussell.zsh-theme
```

## Prompt

Prompt style:

```text
➜ project git:(main)
```

Examples:

```text
➜ project git:(main)
➜ project git:(main +)
➜ project git:(main ±)
➜ project git:(main ?)
➜ project git:(main +±?)
➜ project git:(main ⇡)
➜ project git:(main ⇣)
➜ project git:(main ⇕)
➜ project git:(main +±?⇡)
```

### Git Status Symbols

| Symbol | Meaning |
|----------|----------|
| `+` | staged changes |
| `±` | modified/deleted tracked files |
| `?` | untracked files present |
| `⇡` | commits waiting to be pushed |
| `⇣` | branch behind remote |
| `⇕` | branch diverged from remote |

The prompt intentionally does not show file counts.

## Configuration

### zprofile

Contains:

- Homebrew initialization
- PATH configuration
- Editor configuration

Typical settings:

```bash
export EDITOR=vim
export VISUAL=vim

eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Aliases

Stored in:

```text
~/.oh-my-zsh/custom/wesley-aliases.zsh
```

Examples:

```bash
alias master='git fetch origin; git rebase origin/master'
alias main='git fetch origin; git rebase origin/main'
```

### Functions

Stored in:

```text
~/.oh-my-zsh/custom/wesley-functions.zsh
```

Examples:

```bash
gfetch branch-name
dusort
```

## Updating Oh My Zsh

Update Oh My Zsh:

```bash
cd ~/.oh-my-zsh
git pull
```

Reapply customizations if necessary:

```bash
./install-customized.sh
```

## Backup

The installer automatically creates backups before modifying:

```text
~/.zshrc.backup.<timestamp>
~/.zprofile.backup.<timestamp>
```

## Notes

Preferences:

- vim
- bindkey -v
- modern Oh My Zsh prompt
- compact git status indicators
- no host/path clutter
- customizations separated from upstream

## License

Personal use.
