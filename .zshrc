# set base env
source $HOME/.config/shell/env

settings=(base
    aliases
    keybindings
    colours
    vcs-prompt)

plugins=(dirmark
    command-launcher
    git
    fzf
    fzf-dirmark
    fzf-functions
    fzf-subdir
    fzf-git
    google-cloud
    kubectl
    fzf-kubectl
    docker
    apt
    brew
    github
    ssh-agent)

site=(site)

source $HOME/.config/zsh/init.zsh

PROMPT='%B${_gcp_project_ps1} [%T] %n %~ ${vcs_info_msg_0_}%b${prompt_newline}λ '
