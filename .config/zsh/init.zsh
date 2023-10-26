zsh-file-exists() {
    [[ -f $1 ]]
}

# load configs
for cfg in $configs; do
    cfgfile="${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/$cfg.zsh"
    if ! zsh-file-exists $cfgfile; then
        echo "zsh config file not found: $cfgfile"
        continue
    fi
    source $cfgfile
done

for plugin in $plugins; do
    plugfile="${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/plugins/$plugin.zsh"
    if ! zsh-file-exists $plugfile; then
        echo "zsh plugin file not found: $plugfile"
        continue
    fi
    source $plugfile
done
