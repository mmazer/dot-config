[[ -f "$HOME/.local/share/zsh/pre-hook.zsh" ]] && source "$HOME/.local/share/zsh/pre-hook.zsh"

settings=(
    base
    aliases
    keybindings
    vcs-prompt)

plugins=(
    colors
    dirmark
    command-launcher
    kv
    git
    fzf
    fzf-dirmark
    fzf-git
    google-cloud
    kubectl
    fzf-kubectl
    docker
    apt
    brew
    github
    ssh-agent
    helm
    calc
    agenda)

source $HOME/.config/zsh/init.zsh

PROMPT='%F{green}%D{%H:%M:%S}%f ${_gcp_project_ps1} %F{grey}%n %~%f %F{red}${vcs_info_msg_0_}%f${prompt_newline}%F{yellow}λ%f '

[[ -f "$HOME/.local/share/zsh/post-hook.zsh" ]] && source "$HOME/.local/share/zsh/post-hook.zsh"
