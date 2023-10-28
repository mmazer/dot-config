# set base env
source $HOME/.config/shell/env

settings=(
    base
    aliases
    keybindings
    vcs-prompt)

plugins=(
    colors
    dirmark
    command-launcher
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
    helm)

site=(site)

source $HOME/.config/zsh/init.zsh

PROMPT='%F{green}%D{%H:%M:%S}%f ${_gcp_project_ps1} %F{grey}%n %~%f %F{red}${vcs_info_msg_0_}%f${prompt_newline}%F{yellow}λ%f '
