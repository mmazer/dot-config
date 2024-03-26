0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

snap_deps=(snap)

if ! zn-assert-deps $snap_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $snap_deps"
    return
fi

snap-disabled() {
    snap list --all | awk '/disabled/{print $1, $3}'
}

snap-prune() {
    snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done
}

zn-plugin-status $(zn-plugin-name "$0") "loaded"
