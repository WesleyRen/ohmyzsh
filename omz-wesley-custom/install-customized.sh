#!/bin/bash
set -euo pipefail

CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
THEME_FILE="$CUSTOM_DIR/themes/wesley-robbyrussell.zsh-theme"

mkdir -p "$CUSTOM_DIR/themes"
cp wesley-robbyrussell.zsh-theme "$THEME_FILE"

if [[ ! -f "$HOME/.zshrc" ]]; then
  echo "ERROR: ~/.zshrc not found"
  exit 1
fi

backup="$HOME/.zshrc.backup.$(date +%Y%m%d-%H%M%S)"
cp "$HOME/.zshrc" "$backup"

# Set the theme to wesley-robbyrussell.
if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="wesley-robbyrussell"/' "$HOME/.zshrc"
else
  echo 'ZSH_THEME="wesley-robbyrussell"' >> "$HOME/.zshrc"
fi

# Remove older experimental prompt override if present.
if grep -q 'wesley-git-prompt.zsh' "$HOME/.zshrc"; then
  sed -i '' '/wesley-git-prompt.zsh/d' "$HOME/.zshrc"
fi

echo "Installed wesley-robbyrussell theme."
echo "Backed up ~/.zshrc to: $backup"
echo
echo "Run:"
echo "  source ~/.zshrc"
