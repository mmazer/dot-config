zn-is-file() {
    local file=${1:?"filename required"}
    test -f $file
}

zn-is-dir() {
    local dir=${1:?"directory required"}
    test -d $1
}

zn-is-empty-dir() {
    local dir=${1:?"directory is required"}
    test ! $1(NF)
}

zn-source() {
    local file=${1:?"filename is required"}
    [[ ! -r "$file" ]] && return 1
    source $file
    return 0
}


