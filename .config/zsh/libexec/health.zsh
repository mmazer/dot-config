zn-cmd-health() {
    print "ZSH_CONFIG_HOME: $ZSH_CONFIG_HOME"
    print "ZSH_PLUGIN_HOME: $ZSH_PLUGIN_HOME"
    print "ZSH_DATA_HOME: $ZSH_DATA_HOME"
    printf "\n--- configs ---\n"
    print $configs
    printf "\n--- available plugins  ---\n"
    zn-plugin-available
    printf "\n--- enabled plugin status ---\n"
    zn-plugin-enabled
}
