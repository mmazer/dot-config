source ~/.config/bash/env
source ~/.config/bash/aliases
source ~/.config/bash/profile
source ~/.config/bash/functions
source ~/.config/bash/colours
source ~/.config/bash/bashmarks
source ~/.config/bash/git
source ~/.config/bash/prompt
source ~/.config/bash/fzf

# only run if in interactive shell
[[ $- == *i* ]] && source ~/.config/bash/ssh-agent

[ -f ~/.config/local/bashrc ] &&  source ~/.config/local/bashrc

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
