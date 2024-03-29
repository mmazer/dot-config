#!/bin/bash

usage () {
    sed -e 's/^//' <<End
Usage: fm [-ld:e:h] [-p file] [-P preview_cmd]
Simple file manager
-d specify base directory
-l list files
-e edit file
-o open file in default system application
-n create new note
-p print file
-P specify preview cmd
-h show help
End
    exit 1
}

abort() {
    echo "$1"
    exit 1
}

quit () {
    exit 0
}

assert_file() {
    file="$1"
    if [ ! -f "$file" ]; then
        abort "file not found $file"
    fi
}

list_files () {
    find "$FILEMAN_DIR" -type f ! -path "${FILEMAN_DIR}/.git/*" -printf "%P\n"| sort
}

print_file() {
    file=$(file_path "$1")
    assert_file "$file"
    ${PAGER:-less} "$file"
}

edit_file() {
    file=$(file_path "$1")
    assert_file "$file"
    ${EDITOR:-nvim} "$file"
}

open_file() {
    file=$(file_path "$1")
    assert_file "$file"
    xdg-open "$file"
}

create_file() {
    ${EDITOR:-nvim} "$FILEMAN_DIR/$1"
}

file_path() {
    echo "${FILEMAN_DIR}/$1"
}

FILEMAN_DIR="${FILEMAN_DIR:-$HOME/.local/share/filemanager}"
export FILEMAN_DIR

while getopts ld:he:n:o:p:P: opt
do case "$opt" in
    h) usage;;
    d) FILEMAN_DIR="$OPTARG";;
    e) edit_file "$OPTARG" && quit;;
    l) list_files && quit;;
    o) open_file "$OPTARG" && quit;;
    n) create_file "$OPTARG" && quit;;
    p) print_file "$OPTARG" && quit;;
    P) preview_cmd="$OPTARG";;
    *) usage;;
    esac
done
shift $((OPTIND-1))

if [ ! -d "${FILEMAN_DIR}" ]; then
    abort "file manager directory not found: $FILEMAN_DIR"
fi

if [ "$#" -eq 0 ]; then
    [[ "$(command -v fzf)" ]] || { echo "fzf is not installed" 1>&2 ; usage; }
    out=$(find "$FILEMAN_DIR" -type f ! -path "${FILEMAN_DIR}/.git/*" -printf "%P\n" | \
        fzf --preview "${preview_cmd:-cat} $FILEMAN_DIR/{}" \
        --preview-window=right:70%:wrap --expect=ctrl-e,ctrl-o,ctrl-n)
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    case $key in
        ctrl-e) 
            edit_file "$file";;
        ctrl-o)
            open_file "$file";;
        ctrl-n) 
            read -rp "Enter filename: " filename
            create_file "$filename"
            ;;
        *) 
            if [ -n "$file" ]; then print_file "$file"; fi
            ;;
    esac
    quit
fi

print_file "$1"

