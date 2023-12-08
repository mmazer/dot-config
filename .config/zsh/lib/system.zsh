_zn_uname=$(uname -s)

zn-uname() {
    print "${_zn_uname:l}"
}

zn-open() {
    local fileorurl=$1
    if [[ -z "$fileorurl" ]]; then
        echo "file or URL required"
        return 1
    fi
    local os=$(zn-uname)
    case $os in
        darwin) open "$fileorurl" ;;
        linux) xdg-open "$fileorurl";;
        *) ;;
    esac
}
