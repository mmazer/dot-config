0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

gh_todo_deps=(gh)
if ! zn-assert-deps $gh_todo_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $gh_todo_deps"
    return
fi

gh-todo() {
    gh issue -R "${ZSH_TODO_REPO}" "$@"
}

gh-add-labels() {
    if [[ $# -lt 2 ]]; then
        printf "usage: %s issue label1,label2...\n" $0
        return 1
    fi

    gh-todo edit "$1" --add-label "$2"
}

gh-rm-labels() {
    if [[ $# -lt 2 ]]; then
        printf "usage: %s issue label1,label2...\n" $0
        return 1
    fi
    gh-todo edit "$1" --remove-label "$2"
}

gh-comment() {
    if [[ $# -lt 2 ]]; then
        printf "usage: %s issue comment\n" $0
        return 1
    fi
    gh-todo comment "$1" --body "$2"
}

gh-list-labels() {
    if [[ $# -lt 1 ]]; then
        printf "usage: %s label1 label2 ...\n" $0
        return
    fi
    local label
    local labels=()
    for label in "$@"; do
        labels+=(--label $label)
    done
    gh-todo list $labels
}

gh_todo_aliases=(
     td 'gh-todo'
     tda 'gh-todo list -s all'
     tdc 'gh-todo close'
     tdcc gh-comment
     tde 'gh-todo edit'
     tdl 'gh-todo list'
     tdla gh-add-labels
     tdll gh-list-labels
     tdlr gh-rm-labels
     tdv 'gh-todo view'
     tdw 'gh repo view ${ZSH_TODO_REPO} --web'
)

zn-aliases $gh_todo_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
