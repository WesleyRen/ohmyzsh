# Wesley Oh My Zsh Customization

This package keeps Oh My Zsh mostly stock, while moving Wesley-specific behavior into `$ZSH_CUSTOM`.

## Install

```bash
chmod +x install-customized.sh
./install-customized.sh
source ~/.zshrc
```

## What it does

- Uses a custom theme based on the modern `robbyrussell` prompt.
- Adds compact git status counts:

```text
➜  repo git:(main +1 -2 ~3 ?4)
```

Meaning:

- `+` added files
- `-` deleted files
- `~` modified/renamed/type-changed files
- `?` untracked files

## Files installed

```text
$ZSH_CUSTOM/wesley.zsh
$ZSH_CUSTOM/wesley-aliases.zsh
$ZSH_CUSTOM/wesley-functions.zsh
$ZSH_CUSTOM/themes/wesley-robbyrussell.zsh-theme
```

## Design

Do not edit upstream Oh My Zsh files. Keep your fork synced from upstream, and keep personal changes in `custom/`.
