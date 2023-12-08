zn-is-fn() {
    local fn=${1:?"function name required"}
    declare -f $fn > /dev/null
}

zn-cmd-exists() {
    local cmd=${1:?"command name required"}
    (( $+commands[$cmd] ))
}

zn-has-key() {
    local array_name=${1:?"associative array name required"}
    local key=${2:?"key required"}
    local lookup="${array_name}[$key]"
    (( ${(P)+${lookup}} )) && return 0
    return 1
}


