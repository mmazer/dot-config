0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

_kube_ctx_ps1=""

kubectl_deps=(kubectl fzf)
if ! zn-assert-deps $kubectl_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $kubectl_deps"
    return
fi

ZSH_KUBE_PROMPT_FORMAT="%s"

kube-ctx-precmd() {
    local ctx=$(kvget kubectl/context)
    if [[ -n "$ctx" ]]; then
        _kube_ctx_ps1=$(printf "$ZSH_KUBE_PROMPT_FORMAT" "$ctx")
    else
        _kube_ctx_ps1=""
    fi
}
precmd_functions+=(kube-ctx-precmd)

kube-ctx-sync() {
    kvput kubectl/context $(kubectl config current-context 2> /dev/null)
    print "$(kvget kubectl/context)"
}

kube-evicted-pods() {
   kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | [{ name: .metadata.name, reason: .status.reason, message: .status.message}]'
}

kube-service-ports() {
    local service=$1
    if [[ -z "$service" ]]; then
        echo "service name required"
        return
    fi
    print $(kubectl get service $service -o jsonpath="{.spec.ports}")
}

kube-context() {
    local ctx=$1
    if [[ -n $ctx ]]; then
        kubectl config use-context $ctx
        kube-ctx-sync
    else
        kubectl config current-context
    fi
}

kube-podenv() {
    local pod=${1:?"pod name required"}
    shift
    kubectl exec $pod "$@" -- env
}

kube-nodes() {
    kubectl get nodes -L cloud.google.com/gke-nodepool
}

kube-node-pods() {
    local node=${1:?"node name required"}
    shift
    kubectl get pods -o wide --field-selector spec.nodeName=$node "$@"
}

kube-context-list() {
    kubectl config get-contexts --no-headers=true -o name
}

fzf-kubectx() {
    local ctx=$(kubectl config get-contexts --no-headers=true -o name | fzf)
    [[ -n "$ctx" ]] && kube-context $ctx
}

kubectl_aliases=(
     k kubectl
     kapi 'kubectl api-resources'
     kdel 'kubectl delete'
     kd 'kubectl describe'
     kex 'kubectl explain'
     kg 'kubectl get'
     kgy 'kubectl get -o yaml'
     kpf "kubectl port-forward"
     kn kube-nodes
     knp kube-node-pods
     ks 'kubectl get services'
     ktx kube-context
     ktxz fzf-kubectx
     kube 'kubectl'
     kver 'kubectl version -o yaml'
)
zn-aliases $kubectl_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
