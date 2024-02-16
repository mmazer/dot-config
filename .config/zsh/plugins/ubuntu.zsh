0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ ! "$(zn-uname)" == "linux" ]]; then
    zn-plugin-status $(zn-plugin-name "$0") "not available: operating system not supported"
    return
fi

cso() {
    local name=${1:?"command name required"}
    local cmd=$(which $name)
    if [[ -z "$cmd" ]]; then
        print "command not found: $name"
        return
    fi
    ldd $cmd
}

slib() {
    if [[ $# < 1 ]]; then
        printf "usage: %s pattern\n" $0
        return 1
    fi
    ldconfig -p | grep "$1"
}

dulog() {
    sudo journalctl --disk-usage
}

vacuum-log() {
    sudo journalctl --vacuum-time=3d
}

ubuntu_aliases=(
    dul dulog
    vcl vacuum-log
    routes 'ip route list'
)
zn-aliases $ubuntu_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
