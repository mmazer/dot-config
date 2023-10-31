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
    agenda
    openssl
)

source $HOME/.config/zsh/init.zsh

PROMPT='%F{green}%D{%H:%M:%S}%f %F{red}${_gcp_project_ps1}%f %F{grey}%n %~%f %F{red}${vcs_info_msg_0_}%f${prompt_newline}%F{yellow}λ%f '
