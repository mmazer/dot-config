0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

apt_deps=(apt)

if ! zn-assert-deps $apt_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $apt_deps"
    return
fi

apt_aliases=(
    sap "sudo apt"
    api "sap install"
    apli 'sap list --installed'
    aplu 'sap list --upgradeable'
    aprm 'sap remove'
    apug 'sap upgrade'
    apup 'sap update'
)

zn-aliases $apt_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
