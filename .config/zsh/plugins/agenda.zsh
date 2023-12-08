0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

agenda-dir() {
    print -n "${ZAGENDA_DIR:-$XDG_DATA_HOME/agenda}"
}

agenda-path() {
    local agdir="$(agenda-dir)"
    print -n "$agdir/$1.md"
}

agenda() {
    local agdate="${1:-$(zn-date-today)}"
    ${EDITOR:-nvim} "$(agenda-path $agdate)"
}

agenda-view() {
    local agdate="${1:-$(zn-date-today)}"
    local agpath="$(agenda-path $agdate)"
    if ! zn-is-file "$agpath" ]]; then
        print "no agenda for $agdate"
        return 1
    fi
    cat "$agpath"
}

agenda-find() {
    rg --type markdown "$@" "$(agenda-dir)"
}

agenda-list() {
    for agenda in "$(agenda-dir)"/*.md; do
        print "${agenda:t:r}"
    done
}

agenda-del() {
    local agdate="${1:-$(zn-date-today)}"
    local agpath="$(agenda-path $agdate)"
    if ! zn-is-file "$agpath" ]]; then
        print "no agenda for $agdate"
        return 1
    fi
    read "delete?Delete agenda $agdate? (y) "
    [[ $delete -eq "y" ]] && rm "$agpath"
}

agenda_aliases=(
    ag agenda
    agd agenda-del
    agf agenda-find
    agl agenda-list
    agv agenda-view
)

zn-aliases $agenda_aliases

zn-plugin-status $(zn-plugin-name ${0}) "loaded"
