# goto to bookmarked directory
fzf-dirmarks() {
    local bookmark
    bookmark=$(cat $XDG_DATA_HOME/bookmarks/zsh | awk '{ printf "%s\n", $2}' FS=\| | fzf)
    [[ -n "$bookmark" ]] && dirmark-jump "$bookmark"
}

bindkey -s '^G' 'fzf-dirmarks\n'
