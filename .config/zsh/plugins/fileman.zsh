0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

fileman_deps=(fzf bfs)

if ! zn-assert-deps $fileman_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $fileman_deps"
    return
fi

zfm() {
    local PREVIEW_CMD=${ZFM_PREVIEW_CMD:-cat} EDITOR=${ZFM_EDITOR:-${EDITOR}}
    local DIR=${1:-$(pwd)}
    if [[ ! -d "$DIR" ]]; then
        printf "not a directory: %s\n" "$DIR"
        return 1
    fi
    local FINDFILES="bfs $DIR -type f -not -path '*/.git/*' -printf '%P\n'"
    FZF_DEFAULT_COMMAND="$FINDFILES" \
        fzf -e --preview "$PREVIEW_CMD $DIR/{}" \
        --prompt "Files> " \
        --header "$DIR" \
        --layout=reverse \
        --bind "enter:execute:cd $DIR; $EDITOR $DIR/{}" \
        --bind "enter:+reload|$FINDFILES|" \
        --bind "ctrl-d:execute:(rm -i $DIR/{})" \
        --bind "ctrl-d:+reload|$FINDFILES|" \
        --bind "ctrl-f:execute:cd $DIR; $EDITOR" \
        --bind "ctrl-f:+reload|$FINDFILES|" \
        --bind "ctrl-r:reload|$FINDFILES|" \
        --bind "ctrl-delete:clear-query" \
        --preview-window=right:70%:wrap
}

zn-plugin-status $(zn-plugin-name "$0") "loaded"
