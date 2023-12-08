alias -- -='cd -'
alias cd..='cd ..'
alias cls=clear
alias d='dirs -v'
# create aliases dir dir stack
for index ({1..9}) alias "$index"="cd +${index}"; unset index
alias ddir='rm -rf'
alias del='rm -f'
alias e=nvim
alias alg='alias | grep'
alias envg='env | grep'
alias histg='history | grep'
alias h=history
alias ls='ls --color'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias lsa='ls -ld .*'
alias lsat='ls -ltu' # access time
# List only directories and symbolic
# links that point to directories
alias lsd=' ls -ld *(-/DN)'
alias lst='ls -latr' # reverse time
alias lsz='ls -laS' # sort by size
alias ls1='ls -1'
alias mkexe='chmod 755'
alias mkro='chmod 600'
alias mkdir='mkdir -p'
alias pg='less -R'
alias psg='ps auxw | grep -v grep | grep'
alias wp='echo $PATH' #what path
alias xst='echo $?'
alias xx=exit
alias zdm='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias zo=zn-open
