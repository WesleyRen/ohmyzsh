# Wesley's aliases.

alias ll='ls -lah'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --decorate --graph --all -20'
alias mini='ssh mini-m4'
alias brewup='brew update && brew upgrade && brew cleanup'
alias master='git fetch origin; git rebase origin/master'
alias main='git fetch origin; git rebase origin/main'
alias glg='git log --graph --pretty="%C(yellow)%cs %C(blue)%h %C(red) %s " --date=local'
alias gpull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gclone='git clone --branch master --single-branch --depth 1 '
alias jest='./node_modules/jest/bin/jest.js'
alias root_log="echo -e 'log\tSystem/Volumes/Data/log' | sudo tee -a /etc/synthetic.conf"

# Preserve old Air-specific Python alias only when that interpreter exists.
if [ -x "$HOME/anaconda3/envs/shoptalk/bin/python3" ]; then
  alias python="$HOME/anaconda3/envs/shoptalk/bin/python3"
fi
