zn-autoload() {
    local autoload_dir=${1:?"directory required"}
    if ! zn-is-dir $autoload_dir; then
        print "not a directory: $autoload_dir"
        return
    fi

    fpath=("$autoload_dir" $fpath)
    local fn_list

    # list of functions to load
    if [[ $# -gt 1 ]]; then
        shift
        fn_list=($@)
    fi

    local fn_name fn
    for fn ("$autoload_dir"/*(N)); do
        fn_name=${fn:t}
        if [[ ${#fn_list[@]} -eq 0 ]]; then
            autoload -U $fn_name
            continue
        fi
        # only load specified functions
        if [[ $fn_list[(ie)$fn_name] -le ${#fn_list[@]} ]]; then
            autoload -U $fn_name
        fi
     done
}

alias zauto='autoload -U'
alias zunf='unfunction'
