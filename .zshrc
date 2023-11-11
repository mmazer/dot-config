# automatically remove duplicates from these arrays
# to take affect use path+=()
typeset -U path cdpath fpath manpath

settings=(
    colors
    completion
    history
    prompt
    aliases
    keybindings
    vcs-prompt
)

plugins=(
    zinc
    agenda
    dirmark
    kv
    git
    fzf
    google-cloud
    google-secrets
    kubectl
    docker
    apt
    brew
    github
    ssh-agent
    helm
    calc
    agenda
    openssl
    gh-todo
    fileman
    www-bookmarks
    ubuntu
    backup
)

source $HOME/.config/zsh/init.zsh

PROMPT='%F{green}%D{%H:%M:%S}%f [%F{yellow}${_gcp_project_ps1}%f|%F{yellow}${_kube_ctx_ps1}%f] %F{grey}%n %~%f %F{red}${vcs_info_msg_0_}%f${prompt_newline}%F{yellow}λ%f '
