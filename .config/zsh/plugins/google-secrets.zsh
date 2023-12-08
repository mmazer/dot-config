0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

google_secrets_deps=(gcloud)
if ! zn-assert-deps $google_secrets_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $google_secrets_deps"
    return
fi

gs-list() {
    gcloud secrets list "$@"
}

gs-search() {
    local pattern=${1:?"search pattern required"}
    shift
    gcloud secrets list "$@" | grep "$pattern"
}

gs-versions() {
    local secret=${1:?"secret name required"}
    shift
    gcloud secrets versions list "$@" $secret
}

gs-access() { local secret version all_versions exits
    secret=${1:?"secret name required"}
    shift
    version=${1}
    if [[ -z "${version}" ]]; then
        print -P  "%F{yellow}-- no version provided; fetching versions --%f"
        all_versions=$(gs-versions "$secret")
        if [[ $? -ne 0 ]]; then
            return 1
        fi
        print "${all_versions}\n"
        read "version?Select secret version or (q) to quit "
        [[ $version -eq "q" ]] && return 0
    else
        shift
    fi
    print ""
    print $(gcloud secrets versions access $version --secret=$secret "$@")
}

google_secrets_aliases=(
    gsa gs-access
    gsl gs-list
    gsm 'gcloud secrets'
    gss gs-search
    gsv gs-versions
)

zn-aliases $google_secrets_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
