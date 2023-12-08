0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

helm_deps=(helm kubectl fzf)
if ! zn-assert-deps $helm_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "not available: missing one or more dependencies"
    return
fi

helm-help() {
    sed -e 's/^//' <<End
fzf-helm-context        choose context for 'helm --kube-context'
fzf-helm-setcontext     choose context and set HELM_KUBECONTEXT
helm-unset              unset HELM_KUBECONTEXT
End
}

fzf-helm-context() {
    local ctx=$(kubectl config get-contexts --no-headers=true -o name | fzf)
    [[ -n "$ctx" ]] && print -z "helm --kube-context $ctx"
}

fzf-helm-setcontext() {
    local ctx=$(kubectl config get-contexts --no-headers=true -o name | fzf)
    [[ -n "$ctx" ]] && export HELM_KUBECONTEXT="$ctx"
}

helm-unset() {
    unset HELM_KUBECONTEXT
}

helm_aliases=(
     hh helm
     hhd 'helm dependencies'
     hhg 'helm install --debug --dry-run'
     hhc fzf-helm-context
     hhcs fzf-helm-setcontext
     hhl 'helm list'
     hhm 'helm get manifest'
     hhpl 'helm pull'
     hhr 'helm repo list'
     hhs 'helm status'
     hhu fzf-helm-unset
     hhv 'helm get values'
     hhy 'helm history'
)
zn-aliases $helm_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
