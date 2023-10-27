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

PROMPT='%B[%T] ${_gcp_project_ps1} %n %~ ${vcs_info_msg_0_}%b${prompt_newline}λ '
