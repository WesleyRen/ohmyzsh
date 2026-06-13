# Wesley's aliases.

alias ll='ls -lah'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --decorate --graph --all -20'
alias mini='ssh mini-m4'
alias brewup='brew update && brew upgrade && brew cleanup'

# Preserve old Air-specific Python alias only when that interpreter exists.
if [ -x "$HOME/anaconda3/envs/shoptalk/bin/python3" ]; then
  alias python="$HOME/anaconda3/envs/shoptalk/bin/python3"
fi
