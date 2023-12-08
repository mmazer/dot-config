0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

_bookmarks="$XDG_DATA_HOME/bookmarks/shell"

dirmark_deps=(fzf)

if ! zn-assert-deps $dirmark_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $dirmark_deps"
    return
fi

# Create _bookmarks_file it if it doesn't exist
if [[ ! -f $_bookmarks ]]; then
    touch $_bookmarks
fi

dirmark (){
    local name=$1
    local cwd=$(pwd)
    if [[ -z $name ]]; then
        name="$(basename $cwd)"
    fi

    local bookmark="`pwd`|$name" # Store the bookmark as folder|name
    if [[ -z `grep -e "|${name}$" $_bookmarks` ]]; then
        echo $bookmark >> $_bookmarks
        echo "Bookmark '$name' saved for $cwd"
    else
        read "replace?Bookmark '$name' already exists. Replace it? (y or n)"
        case $replace in
            y)
                # Delete existing bookmark
                sed "/.*|$name/d" $_bookmarks > ~/.tmp && mv ~/.tmp $_bookmarks
                # Save new bookmark
                echo $bookmark >> $_bookmarks
                echo "Bookmark '$name' saved"
                ;;
            n)
                return;;
        esac
    fi
}

# Show a list of the _bookmarks
dirmark-list(){
    cat $_bookmarks | awk '{ printf "%-80s%-40s%s\n",$1,$2,$3}' FS=\|
}

dirmark-jump(){
    local mark=$1

    bookmark=`grep "|${mark}$" "$_bookmarks"`

    if [[ -z $bookmark ]]; then
        echo 'Invalid name, please provide a valid bookmark name. For example:'
        echo '  go foo'
        echo
        echo 'To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):'
        echo '  bookmark foo'
    else
        dir=`echo "$bookmark" | cut -d\| -f1`
        cd "$dir"
    fi
}

dirmark-edit () {
    ${EDITOR:-vim} "$_bookmarks"
}

# goto to bookmarked directory
fzf-dirmark() {
    local bookmark=$(cat $XDG_DATA_HOME/bookmarks/shell | awk '{ printf "%s\n", $2}' FS=\| | fzf)
    [[ -n "$bookmark" ]] && dirmark-jump "$bookmark"
}

bindkey -s '^G' 'fzf-dirmark\n'

dirmark_aliases=(
     j dirmark-jump
     mark dirmark
     marks dirmark-list
     marked dirmark-edit
)
zn-aliases $dirmark_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
