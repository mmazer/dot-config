0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

backup_deps=(bzip2 envsubst)

if ! zn-assert-deps $backup_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $backup_deps"
    return
fi

_backup-usage() {
    sed -e 's/^//' <<End
Usage: zbup [-d dest_dir] [-f base_filename]
Backup from file manifest
-b base filename for backup (default `backup-YYYYMMDDTHHMMSS`
-d destination dir (default ".")
-m file manifest for backup (default $XDG_CONFIG_HOME/backup/files)
-h show help
End
}

backup() {
    local OPTIND base_filename="backup" destination="." tarfile envsub rc
    local manifest="$XDG_CONFIG_HOME/backup/files"

    while getopts  "b:d:m:h" opt; do
        case $opt in
            b)
                base_filename="$OPTARG";;
            d)
                destination="$OPTARG";;
            m)
                manifest="$OPTARG";;
            h)
                _backup-usage
                return;;
            *)
                _backup-usage
                return;;
        esac
    done
    shift $((OPTIND-1))

    # strip trailing slash
    destination=${destination%*/}

    if [[ ! -d "$destination" ]]; then
        print "backup destination is not a directory: $destination"
        return
    fi

    if [[ ! -f "$manifest" ]]; then
        print "backup manifest not found: $manifest"
        return
    fi

    tarfile="${destination}/${base_filename}-$(zn-date-timestamp).tar.bz2"

    printf "-- backing up from manifest $manifest to $tarfile --\n"

    envsub=$(envsubst < $manifest)
    rc="$?"
    if [[ $rc -ne -0 ]]; then
        print "env substitution error: $rc"
    fi
    print $envsub | tar --bzip2 -cvf "$tarfile" -T -
    printf "---\n"
    ls -l $tarfile

}

zn-plugin-status $(zn-plugin-name "$0") "loaded"
