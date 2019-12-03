source ~/.config/bash/env
source ~/.config/bash/direnv
source ~/.config/bash/aliases
source ~/.config/bash/profile
source ~/.config/bash/functions
source ~/.config/bash/kdb
source ~/.config/bash/colours
source ~/.config/bash/theme
source ~/.config/bash/bashmarks
source ~/.config/bash/git
source ~/.config/bash/prompt
source ~/.config/bash/fzf
source ~/.config/bash/ssh-agent
source ~/.config/bash/python

[ -n $(command -v docker) ] && source ~/.config/bash/docker

[ -n $(command -v kubectl) ] && source ~/.config/bash/kube

[ -n $(command -v gcloud) ] && source ~/.config/bash/gcloud

[ -f ~/.local/share/etc/bashrc ] &&  source ~/.local/share/etc/bashrc
