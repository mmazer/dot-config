0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

_zinc=${0:t:r}

[[ -z "$ZSH_CONFIG_HOME" ]] && export ZSH_CONFIG_HOME="${0:A:h}"

# check zsh state dir
if [[ -z "$ZSH_STATE_HOME" ]]; then
    export ZSH_STATE_HOME="$XDG_STATE_HOME/zsh"
fi
[[ ! -d "$ZSH_STATE_HOME" ]] && mkdir -p "$ZSH_STATE_HOME"

# check zsh cache dir
if [[ -z "$ZSH_CACHE_HOME" ]]; then
    export ZSH_CACHE_HOME="$XDG_CACHE_HOME/zsh"
fi
[[ ! -d "$ZSH_CACHE_HOME" ]] && mkdir -p "$ZSH_CACHE_HOME"

# check zsh data dir
if [[ -z "$ZSH_DATA_HOME" ]]; then
    export ZSH_DATA_HOME="$XDG_DATA_HOME/zsh"
fi
[[ ! -d "$ZSH_DATA_HOME" ]] && mkdir -p "$ZSH_DATA_HOME"

# check zsh plugin dir
if [[ -z "$ZSH_PLUGIN_HOME" ]]; then
    export ZSH_PLUGIN_HOME="${ZSH_CONFIG_HOME}/plugins"
fi

fpath=($ZSH_CONFIG_HOME/completion $fpath)

# apply local settings
[[ -r "$ZSH_DATA_HOME/.zshrc" ]] && source "$ZSH_DATA_HOME/.zshrc"

for lib ("$ZSH_CONFIG_HOME"/lib/*.zsh); do
  source "$lib"
done
unset lib

zn-autoload $ZSH_CONFIG_HOME/autoload

for file ($configs); do
    zn-source "${ZSH_CONFIG_HOME}/conf/$file.zsh"
    if [[ $? -gt 0 ]]; then
        printf "%s config file not found or not readable: %s\n" $_zinc ${ZSH_CONFIG_HOME}/${file}.zsh
    fi
done
unset file

for plugin ($plugins); do
    zn-plugin-load $plugin
done
unset plugin

# autoload local user functions
[[ -d $ZSH_DATA_HOME/autoload ]] && zn-autoload $ZSH_DATA_HOME/autoload

# apply any other settings after loading is done
[[ -r "$ZSH_DATA_HOME/.zshrc.after" ]] && source "$ZSH_DATA_HOME/.zshrc.after"
