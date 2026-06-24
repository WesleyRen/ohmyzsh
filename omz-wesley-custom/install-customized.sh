#!/bin/bash
set -euo pipefail

timestamp=$(date +%Y%m%d-%H%M%S)

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "ERROR: Oh My Zsh is not installed."
    exit 1
fi

if [[ ! -f "$HOME/.zshrc" ]]; then
    echo "ERROR: ~/.zshrc not found"
    echo "Install Oh My Zsh first."
    exit 1
fi

CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

mkdir -p "$CUSTOM_DIR"
mkdir -p "$CUSTOM_DIR/themes"

# Install theme
cp wesley-robbyrussell.zsh-theme \
   "$CUSTOM_DIR/themes/wesley-robbyrussell.zsh-theme"

# Install aliases
if [[ -f "wesley-aliases.zsh" ]]; then
    cp wesley-aliases.zsh "$CUSTOM_DIR/"
fi

# Install functions
if [[ -f "wesley-functions.zsh" ]]; then
    cp wesley-functions.zsh "$CUSTOM_DIR/"
fi

# Install environment setup (PATH, nvm, conda, Java, vi mode)
if [[ -f "wesley.zsh" ]]; then
    cp wesley.zsh "$CUSTOM_DIR/"
fi

# Install iTerm2 Shell Integration if missing
if [[ ! -f "$HOME/.iterm2_shell_integration.zsh" ]]; then
    echo "Installing iTerm2 Shell Integration..."

    curl -fsSL \
        https://iterm2.com/shell_integration/zsh \
        -o "$HOME/.iterm2_shell_integration.zsh"

    echo "Installed ~/.iterm2_shell_integration.zsh"
fi

# Backup .zshrc
zshrc_backup="$HOME/.zshrc.backup.$timestamp"
cp "$HOME/.zshrc" "$zshrc_backup"

# Set theme
if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
    sed -i '' \
        's/^ZSH_THEME=.*/ZSH_THEME="wesley-robbyrussell"/' \
        "$HOME/.zshrc"
else
    echo 'ZSH_THEME="wesley-robbyrussell"' >> "$HOME/.zshrc"
fi

# Source environment setup exactly once (PATH, nvm, conda, Java, vi mode)
grep -q 'source ~/.oh-my-zsh/custom/wesley.zsh' "$HOME/.zshrc" || \
    echo 'source ~/.oh-my-zsh/custom/wesley.zsh' >> "$HOME/.zshrc"

# Source aliases exactly once
grep -q 'source ~/.oh-my-zsh/custom/wesley-aliases.zsh' "$HOME/.zshrc" || \
    echo 'source ~/.oh-my-zsh/custom/wesley-aliases.zsh' >> "$HOME/.zshrc"

# Source functions exactly once
grep -q 'source ~/.oh-my-zsh/custom/wesley-functions.zsh' "$HOME/.zshrc" || \
    echo 'source ~/.oh-my-zsh/custom/wesley-functions.zsh' >> "$HOME/.zshrc"

# Remove old experimental prompt file if present
sed -i '' '/wesley-git-prompt.zsh/d' "$HOME/.zshrc" || true

# Install .zprofile
zprofile_backup=""

if [[ -f "wesley-zprofile" ]]; then
    if [[ -e "$HOME/.zprofile" ]]; then
        zprofile_backup="$HOME/.zprofile.backup.$timestamp"
        cp "$HOME/.zprofile" "$zprofile_backup"
    fi

    cp wesley-zprofile "$HOME/.zprofile"
    echo "Installed ~/.zprofile"
fi

echo
echo "Installed:"
echo "  Theme"
echo "  Environment (PATH, nvm, conda, Java, vi mode)"
echo "  Aliases"
echo "  Functions"
[[ -f "wesley-zprofile" ]] && echo "  .zprofile"

echo
echo "Backups:"
echo "  $zshrc_backup"
[[ -n "$zprofile_backup" ]] && echo "  $zprofile_backup"

echo
echo "Run:"
echo "  source ~/.zprofile"
echo "  source ~/.zshrc"
