# Wesley's shell customizations.
# Keep this file independent from Oh My Zsh upstream files.

# Prefer Homebrew tools on Apple Silicon.
if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Keep old Intel/Homebrew and MySQL paths if they exist.
[ -d /usr/local/bin ] && export PATH="/usr/local/bin:$PATH"
[ -d /usr/local/mysql/bin ] && export PATH="/usr/local/mysql/bin:$PATH"
# mysql client from keg-only mariadb@10.6 (not linked into /opt/homebrew/bin).
[ -d /opt/homebrew/opt/mariadb@10.6/bin ] && export PATH="/opt/homebrew/opt/mariadb@10.6/bin:$PATH"

# Personal bin/home convenience path from older config.
export PATH="$HOME:$PATH"

# Git completion support if you keep git-completion.bash under ~/.zsh.
if [ -f "$HOME/.zsh/git-completion.bash" ]; then
  zstyle ':completion:*:*:git:*' script "$HOME/.zsh/git-completion.bash"
  fpath=("$HOME/.zsh" $fpath)
fi

# Vi mode and reverse history search.
if test -t 0; then
  bindkey -v
  bindkey '^R' history-incremental-search-backward
  HISTSIZE=5000
  SAVEHIST=5000
fi

# NVM, only when installed.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# iTerm integration, only when installed.
[ -f "$HOME/.iterm2_shell_integration.zsh" ] && source "$HOME/.iterm2_shell_integration.zsh"

# Conda, only when installed. Supports both Wesley's old Air path and common Homebrew/Miniforge paths.
for conda_bin in \
  "$HOME/anaconda3/bin/conda" \
  "$HOME/miniconda3/bin/conda" \
  "/opt/homebrew/Caskroom/miniforge/base/bin/conda" \
  "/opt/homebrew/bin/conda"
do
  if [ -x "$conda_bin" ]; then
    __conda_setup="$($conda_bin shell.zsh hook 2>/dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    fi
    unset __conda_setup
    break
  fi
done

# Java, only if this exact JDK exists.
if [ -d /Library/Java/JavaVirtualMachines/jdk-20.jdk/Contents/Home ]; then
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-20.jdk/Contents/Home
fi
