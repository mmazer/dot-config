0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"


# load zinc commands
for cmd ("$ZSH_CONFIG_HOME"/libexec/*.zsh); do
    source $cmd
done

zinc() {
help() {
    sed -e 's/^//' <<End
Usage: $_zinc_cmd command [OPTIONS]
help: show usage
health: show zinc health
plugin: view plugins

Run "$_zinc_cmd command help" for more information
End
}
    if [[ $# -lt 1 ]]; then
        help
        return
    fi
    local cmd="$1"
    shift
    case $cmd in
        health)
            zn-cmd-health "$@";;
        plugin)
            zn-cmd-plugin "$@";;
        help)
            help;;
        *)
            print "zinc command not found: $cmd"
            help;;
    esac
}

zinc_aliases=(
    z 'zinc'
    zpi 'zinc plugin info'
    zpe 'zinc plugin edit'
    zpf 'zinc plugin fzf'
)
zn-aliases $zinc_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
