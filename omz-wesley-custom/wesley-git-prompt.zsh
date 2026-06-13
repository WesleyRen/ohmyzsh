# Git prompt status: + staged, ± modified, ? untracked

function git_prompt_status_custom() {
    local status=$(git status --porcelain 2>/dev/null)

    local staged=""
    local modified=""
    local untracked=""

    echo "$status" | grep -q '^[MARCD]' && staged="+"
    echo "$status" | grep -q '^.[MTD]' && modified="±"
    echo "$status" | grep -q '^??' && untracked="?"

    echo "${staged}${modified}${untracked}"
}

function git_prompt_info() {
    local ref dirty

    ref=$(git symbolic-ref --short HEAD 2>/dev/null) \
        || ref=$(git rev-parse --short HEAD 2>/dev/null) \
        || return

    dirty=$(git_prompt_status_custom)

    if [[ -n "$dirty" ]]; then
        echo " git:(${ref} ${dirty})"
    else
        echo " git:(${ref})"
    fi
}
