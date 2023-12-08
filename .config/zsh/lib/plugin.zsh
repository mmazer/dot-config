typeset -A _zn_plugin_status

zn-plugin-path() {
    print "${ZSH_PLUGIN_HOME}/$1.zsh"
}

zn-is-plugin() {
    local plugin=${1:?"plugin name required"}
    local path=$(zn-plugin-path $plugin)
    [[ -f $path ]]
}

zn-plugin-name() {
    local path=${1:?"plugin path required"}
    print ${path:t:r}
}

zn-plugin() {
    local plugin=${1:?"plugin name required"}
    local plug_path=$(zn-plugin-path $plugin)
    if ! zn-is-file $plug_path; then
        print "plugin not found: $plugin"
        return 1
    fi
    local plugs=$_zn_plugin_status[$plugin]
    print "path: $plug_path"
    print "status: ${plugs:-'not loaded'}"
}

zn-plugin-load() {
    local plugin=${1:?"plugin name required"}
    local plug_path=$(zn-plugin-path $1)
    if ! zn-is-file $plug_path; then
        print "plugin $plugin not found in $ZSH_PLUGIN_HOME"
        return 1
    fi
    source $plug_path
}
zn-is-plugin-loaded() {
    local plugin=${1:?"plugin name required"}
    if ! zn-has-key _zn_plugin_status $plugin; then
        return 1
    fi
    return 0
}

zn-plugin-available() {
    local plugins=() plug name
    for plug in "$ZSH_PLUGIN_HOME"/*.zsh; do
        name=${plug:t:r}
        plugins+=($name)
    done
    print $plugins
}

zn-plugin-status() {
    local plugin=${1:?"plugin name required"}
    if [[ $# -eq 1 ]]; then
        if ! zn-has-key _zn_plugin_status $plugin; then
            print "plugin not loaded: $plugin"
            return
        fi
        print $_zn_plugin_status[${plugin}]
        return
    fi
    local plugs=${2:?"plugin status required"}
    _zn_plugin_status[$plugin]=$plugs
}

zn-plugin-enabled() {
    local plugin plugs
    for plugin plugs  in ${(kv)_zn_plugin_status}; do
        echo "$plugin -> $plugs"
    done
}

zn-aliases() {
    local name cmd
    for name cmd ($@); do
        alias $name="$cmd"
    done
}

zn-plugin-aliases() {
    local plugin=${1:?"plugin name required"}
    local aliases="${plugin//-/_}_aliases"
    if [[ ! ${(P)${aliases}} ]]; then
        print "no aliases found for plugin $plugin"
        return
    fi
    local name cmd
    for name cmd in ${(P)${aliases}}; do
        print "$name='$cmd'"
    done
}

zn-plugin-help() {
    local plugin=${1:?"plugin name required"}
    if zn-is-fn ${:-${plugin}-help}; then
        ${:-${plugin}-help}
    else
        print "$plugin: no help available"
    fi
}

zn-plugin-deps() {
    local plugin=${1:?"plugin name required"}
    local deps="${plugin//-/_}_deps"
    if [[ ! ${(P)${deps}} ]]; then
        print "no dependencies declared for plugin $plugin"
        return
    fi
    local dep
    for dep in ${(P)${deps}}; do
        printf "%s %s\n" $dep $(whence -p $dep)
    done
}

zn-assert-deps() {
    local dep
    for dep in "$@"; do
        zn-cmd-exists $dep || return 1
    done
    return 0
}

alias zp=zn-plugin
alias zpa=zn-plugin-aliases
alias zpav=zn-plugin-available
alias zph=zn-plugin-help
alias zpd=zn-plugin-deps
alias zpl=zn-plugin-load
alias zpls=zn-plugin-enabled
alias zps=zn-plugin-status
