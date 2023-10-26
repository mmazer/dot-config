# browse shell functions (bash)
fzf-functions() {
    local fn=$(print -rl -- ${(k)functions} | fzf )
    [[ ! -z $fn ]] && declare -f $fn
}
