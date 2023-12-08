0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

_gcp_project_ps1=""

google_cloud_deps=(gcloud kubectl)
if ! zn-assert-deps $google_cloud_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $google_cloud_deps"
    return
fi

ZSH_GCP_PROMPT_FORMAT="%s"

google-cloud-help() {
    sed -e 's/^//' <<End
gcp-activate-project [project]      sets gcloud config for the specified project and fetches default cluster credentials
gke-clusters  [zone]                list GKE clusters; uses GKE_ZONE if zone not specified
gke-cluster-describe [cluster_name] describe the specified cluster; zone must be provided if GKE_ZONE is not set
gke-node-pools [cluster] [zone]     list node pools for the specified cluster
gcp-status                          opens the GCP status web page in a browser
End
}
gcp-project-precmd() {
    local project=$(kvget gcp/project)
    if [[ -n "$project" ]]; then
        _gcp_project_ps1=$(printf "$ZSH_GCP_PROMPT_FORMAT" "$project")
    else
        _gcp_project_ps1=""
    fi
}
precmd_functions+=(gcp-project-precmd)

gcp-project-sync() {
    kvput gcp/project $(gcloud config get-value project)
    print "$(kvget gcp/project)"
}

gcp-project-num() {
    local project=${1:?"project ID required"}
    gcloud projects describe $project --format="value(projectNumber)"
}

gcp-activate-project() {
  local project=$1
  if [[ -z "$project" ]]; then
    echo "no project specified"
    return 1
  fi
  echo "setting active GCP project to $project"
  gcloud config set project "$project"
  # cache active project
  kvput gcp/project $(gcloud config get-value project)
  gcloud container clusters get-credentials ${2:-${GKE_CLUSTER:-application-cluster}} --zone=${2:-${GKE_ZONE}}
  # cache the newly activated context
  kvput kubectl/context $(kubectl config current-context 2> /dev/null)
}

gke-clusters() {
    zone=${1:-${GKE_ZONE}}
    if [[ -z "$zone" ]]; then
      echo "zone required"
      return 1
    fi
    gcloud container clusters list --zone=$zone
}

gke-cluster-describe() {
    local cluster=${1}
    if [[ -z "$cluster" ]]; then
      echo "cluster name required"
      return 1
    fi
    local zone=${2:-${GKE_ZONE}}
    if [[ -z "$zone" ]]; then
      echo "zone required"
      return 1
    fi
    gcloud container clusters describe $cluster --zone $zone
}

gke-node-pools() {
    local cluster=${1:?"cluster name required"}
    shift
    local zone=${1:?"zone required"}
    shift
    gcloud container node-pools "$@" --zone $zone --cluster $cluster
}

gcp-status() {
    zn-open "https://status.cloud.google.com"
}

google_cloud_aliases=(
    gce 'gcloud compute'
    gci 'gcloud compute instances'
    gcp 'gcloud'
    gcp-up 'gcloud components update'
    gcs 'gcloud storage'
    gcurl 'curl -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json"'
    gkc gke-clusters
    gke 'gcloud container'
    gke-creds 'gcloud container clusters get-credentials'
    gkn 'gcloud container node-pools'
    gp 'gcloud config get-value project'
    gps 'gcloud pubsub'
    gpst 'glcoud pubsub topics'
    gsql 'gcloud sql'
    gstat 'zn-open https://status.cloud.google.com/'
    gssh 'gcloud compute ssh'
)
zn-aliases $google_cloud_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
