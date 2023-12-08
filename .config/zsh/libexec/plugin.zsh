zn-cmd-plugin-info() {
    local plugin=${1:?"plugin name required"}
    if ! zn-is-plugin $plugin; then
        printf "plugin not found: %s\n" $plugin
        return
    fi

    if ! zn-is-plugin-loaded $plugin; then
        printf "plugin not loaded: %s\n" $plugin
        return
    fi

    printf "-- status --\n"
    zn-plugin-status "$@"
    printf "\n-- plugin path --\n"
    zn-plugin-path "$@"
    printf "\n--- dependencies --\n"
    zn-plugin-deps "$@"
    printf "\n--- aliases --\n"
    zn-plugin-aliases "$@"
    printf "\n--- help ---\n"
    zn-plugin-help "$@"
}

zn-cmd-plugin-edit() {
    local plugin=${1:?"plugin name required"}
    local plug_path=$(zn-plugin-path $1)
    if ! zn-is-file $plug_path; then
        print "plugin $plugin not found in $ZSH_PLUGIN_HOME"
        return 1
    fi
    ${EDITOR:-vim} $plug_path
}

zn-cmd-plugin-fzf() {
    local PLUGIN_HOME=$ZSH_PLUGIN_HOME
    local out=$(bfs "$PLUGIN_HOME" -type f -name "*.zsh" -printf "%P\n" | sed 's/\.zsh$//1' | \
        fzf --preview "cat $PLUGIN_HOME/{}.zsh" \
        --preview-window=right:70%:wrap --expect=ctrl-e,ctrl-n)
    local key=$(head -1 <<< "$out")
    local name=$(sed 1d <<< "$out")
    local plugin
    case $key in
        ctrl-e)
            [[ -n "$name" ]] && ${EDITOR:-vim} $PLUGIN_HOME/$name.zsh
            ;;
        ctrl-n)
            read "plugin?Enter plugin name: "
            ${EDITOR:-vim} $PLUGIN_HOME/$plugin.zsh
            ;;
        *)
            [[ -n "$name" ]] && cat $PLUGIN_HOME/$name.zsh
            ;;
    esac
}

zn-cmd-plugin() {

help() {
    sed -e 's/^//' <<End
Usage: plugin command [OPTIONS]
help: show usage
list: show loaded plugins
info: show plugin info for <plugin>
fzf: manage plugins interactively
End
}
    if [[ $# -lt 1 ]]; then
        help
        return
    fi
    local cmd="$1"
    shift
    case $cmd in
        list)
            zn-plugin-enabled;;
        help)
            help;;
        info)
            zn-cmd-plugin-info "$@"
            ;;
        edit)
            zn-cmd-plugin-edit "$@"
            ;;
        fzf)
            zn-cmd-plugin-fzf "$@"
            ;;
        *)
            print "zinc plugin command not found: $cmd"
            help;;
    esac
}

