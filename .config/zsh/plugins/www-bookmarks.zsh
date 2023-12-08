0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

www_bookmarks_deps=(fzf)

if ! zn-assert-deps $www_bookmarks_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $www_bookmarks_deps"
    return
fi

www() {
    local BOOKMARKS_DIR="$XDG_DATA_HOME/bookmarks/www"
    local collection datafile data bookmark url
    collection=${1}
    if [[ -n "$collection" ]]; then
        datafile="${BOOKMARKS_DIR}/${collection}/index.dat"
        if [[ ! -r "$datafile" ]]; then
            printf "bookmark collection not found or not readable %s\n" $collection
            return 1
        fi
        data=$(cat $datafile)
    else
        data=$(cat "$BOOKMARKS_DIR"/**/*.dat)
    fi
    bookmark=$(print $data | fzf --bind "ctrl-q:abort")
    if [[ -z "$bookmark" ]]; then
        return
    fi
    url=(${(s/|/)bookmark})
    if [[ ${#url} -ne 2 ]]; then
        printf "malformed bookmark: %s\n" $bookmark
        return 1
    fi
    url=${url[2]}
    if [ -n "$url" ]; then
        echo "opening $url in browser"
        zn-open "$url"
    fi
}


_www-bookmarks-completion() {
    print ""
    bfs -type d -printf "%f\n"  $HOME/.local/share/bookmarks/www/ | grep -v www
}

compdef _www-bookmarks-completion www

www_boomarks_aliases=()

if zn-is-fn zfm; then
    www_bookmarks_aliases+=(wbe 'zfm $XDG_DATA_HOME/bookmarks/www')
fi

zn-aliases $www_bookmarks_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
