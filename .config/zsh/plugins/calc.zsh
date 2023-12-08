0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

calc() {
    if [[ $# -gt 0 ]]; then
        echo "scale=6;" "$@" | bc -l
    else
        print "q to quit"
        while true; do
            read "expr?>"
            case $expr in
                q) break;;
                *)
                    echo "scale=6; $expr" | bc -l
                    ;;
            esac
        done
    fi
}

calc_aliases=(
    qc calc
)
zn-aliases $calc_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
