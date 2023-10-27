# set base env
source $HOME/.config/shell/env

settings=(base
    aliases
    keybindings
    vcs-prompt)

plugins=(dirmark
    fzf-dirmark
    command-launcher
    git
    fzf-functions
    fzf-subdir
    fzf-git
    google-cloud
    kubectl
    docker
    apt
    brew
    github
    ssh-agent)

site=(site)

source $HOME/.config/zsh/init.zsh

PROMPT='%B${_gcp_project_ps1} [%T] %n %~ ${vcs_info_msg_0_}%b${prompt_newline}λ '
