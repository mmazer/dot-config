# Use modern completion system
autoload -Uz compinit

zstyle ':completion:*' menu yes select search
zstyle ':completion:*' format '%F{yellow}-- %d --%f'

[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:git:*' script ~/.config/git/git-completion.bash
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zmodload -i zsh/complist
compinit -d $ZSH_CACHE_HOME/compdump

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# remove need to press <CR> twice
bindkey -M menuselect '^M' .accept-line
