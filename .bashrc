configs="env direnv aliases profile editor functions colours theme \
    bashmarks git prompt fzf python pkms"
for c in $configs
do
    source ~/.config/bash/$c
done

# check for interactive terminal
if [[ $- == *i* ]]; then
    source ~/.config/bash/ssh-agent
fi

commands="docker kubectl gcloud todo.sh helm"
for cmd in $commands
do
    [ -n $(command -v $cmd) ] && source ~/.config/bash/$cmd
done

[ -f $XDG_DATA_HOME/bash/bashrc ] &&  source $XDG_DATA_HOME/bash/bashrc
