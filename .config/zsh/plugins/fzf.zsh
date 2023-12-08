1="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

export FZF_DEFAULT_COMMAND='rg --no-messages --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS="--color=bg+:-1,fg+:#ADD8E6,gutter:-1,hl:#00A36C"

fzf_deps=(fzf)
if ! zn-assert-deps $fzf_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $fzf_deps"
    return
fi

# list subdirectories in current directory and change to selected directory
fzf-cd() {
  local dir=$(fd --max-depth 1 --type d . | fzf)
  [[ -n "dir" ]] && cd "$dir"
}

fzf-functions() {
    local out=$(print -rl -- ${(k)functions} |  fzf --expect=ctrl-e,alt-p)
    local key=$(head -1 <<< "$out")
    local fn=$(head -2 <<< "$out" | tail -1)
    case $key in
        alt-p)
            print -z "$fn";;
        ctrl-e)
            eval "$fn";;
    *)
        [[ ! -z $fn ]] && declare -f $fn;;
    esac
}

fzf-history() {
    local out=$(fc -l 1 | sed 's/^[ \t]*//' | fzf --tac --expect=ctrl-e )
    if [[ -n $out ]]; then
        local key=$(head -1 <<< "$out")
        local hc=$(head -2 <<< "$out" | tail -1)
        local num="${hc%%' '*}"
        local cmd="${hc#*' '}"
        if [ "$key" = ctrl-e ]; then fc "$num"; else eval "$cmd"; fi
    fi
}

fzf-edit() {
    local file=$(fzf) && ${EDITOR} "$file";
}

fzf_aliases=(
     zed fzf-edit
     zh fzf-history
     lcd fzf-cd
     zf fzf-functions
)
zn-aliases $fzf_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
