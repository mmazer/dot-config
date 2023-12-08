0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

openssl_deps=(openssl)
if ! zn-assert-deps $openssl_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $openssl_deps"
    return
fi

openssl-view-cert() {
    local cert=$1
    if [[ -z "$cert" ]] || [[ ! -f "$cert" ]]; then
        echo "certificate file required"
        return 1
    fi
    openssl crl2pkcs7 -nocrl -certfile "$cert" | openssl pkcs7 -print_certs -text -noout
}

openssl-check-cert() {
    local host=$1
    if [[ -z "$host" ]]; then
        echo "host and port required"
        return 1
    fi
    shift
    openssl s_client "$@" -connect $host
}

zn-plugin-status $(zn-plugin-name "$0") "loaded"
