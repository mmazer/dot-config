source ~/.config/bash/env
source ~/.config/bash/aliases
source ~/.config/bash/profile
source ~/.config/bash/functions
source ~/.config/bash/colours
source ~/.config/bash/bashmarks
source ~/.config/bash/git
source ~/.config/bash/prompt

# only run if in interactive shell
[[ $- == *i* ]] && source ~/.config/bash/ssh-agent

[ -f ~/.local/share/etc/bashrc ] &&  source ~/.local/share/etc/bashrc

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
