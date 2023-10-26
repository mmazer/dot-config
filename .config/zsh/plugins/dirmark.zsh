bookmarks=$XDG_DATA_HOME/bookmarks/zsh

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $bookmarks ]]; then
    touch $bookmarks
fi

dirmark-cwd (){
    local mark=$1
    local cwd=$(pwd)
    if [[ -z $mark ]]; then
        mark="$(basename $cwd)"
    fi

    local bookmark="`pwd`|$mark" # Store the bookmark as folder|name
    if [[ -z `grep -e "|${mark}$" $bookmarks` ]]; then
        echo $bookmark >> $bookmarks
        echo "Bookmark '$mark' saved for $cwd"
    else
        read -q "replace?Bookmark '$mark' already exists. Replace it? (y or n)"
        case $replace in 
            y)
                # Delete existing bookmark
                sed "/.*|$bookmark_name/d" $bookmarks_file > ~/.tmp && mv ~/.tmp $bookmarks_file
                # Save new bookmark
                echo $bookmark >> $bookmarks_file
                echo "Bookmark '$bookmark_name' saved"
                ;;
            n)
                return;;
        esac
    fi
}

# Show a list of the bookmarks
dirmark-list(){
    cat $bookmarks | awk '{ printf "%-80s%-40s%s\n",$1,$2,$3}' FS=\|
}

dirmark-jump(){
    local mark=$1

    bookmark=`grep "|${mark}$" "$bookmarks"`

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
    ${EDITOR:-vim} "$bookmarks"
}

_dirmark-completion() {
  cat $bookmarks | cut -d\| -f2 | grep "$2.*"
}

compdef _dirmark-completion dirmark-jump

alias dj=dirmark-jump
alias mark=dirmark-cwd
alias marks=dirmark-list
alias marked=dirmark-edit

