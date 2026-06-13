# wesley-robbyrussell.zsh-theme
# Robbyrussell-style prompt with compact git status:
#   + staged changes
#   ± unstaged modified/deleted changes
#   ? untracked files
#
# Examples:
#   ➜  project git:(main)
#   ➜  project git:(main +)
#   ➜  project git:(main ±)
#   ➜  project git:(main +±?)
#
# This intentionally does NOT show counts like ?1.

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

function wesley_git_status_symbols() {
  local git_status
  git_status="$(git status --porcelain 2>/dev/null)" || return

  local staged=""
  local modified=""
  local untracked=""
  local remote=""

  # First column = index/staged status.
  echo "$git_status" | grep -q '^[MADRCU]' && staged="+"

  # Second column = working tree status.
  echo "$git_status" | grep -q '^.[MD]' && modified="±"

  # Untracked files.
  echo "$git_status" | grep -q '^??' && untracked="?"

  # Remote tracking status.
  local ahead behind

  ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
  behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

  if [[ -n "$ahead" && -n "$behind" ]]; then
    if (( ahead > 0 && behind > 0 )); then
      remote="⇕"
    elif (( ahead > 0 )); then
      remote="⇡"
    elif (( behind > 0 )); then
      remote="⇣"
    fi
  fi

  echo "${staged}${modified}${untracked}${remote}"
}

function wesley_git_prompt_info() {
  local ref symbols

  ref="$(git symbolic-ref --short HEAD 2>/dev/null)" \
    || ref="$(git rev-parse --short HEAD 2>/dev/null)" \
    || return

  symbols="$(wesley_git_status_symbols)"

  if [[ -n "$symbols" ]]; then
    echo "git:(${ref} ${symbols})"
  else
    echo "git:(${ref})"
  fi
}

PROMPT='${ret_status}%{$fg_bold[red]%}➜ %{$fg_bold[cyan]%}%c %{$fg_bold[blue]%}$(wesley_git_prompt_info)%{$reset_color%} '

PROMPT+='$(git_prompt_status)%{$reset_color%}'

RPROMPT='${return_code}'
