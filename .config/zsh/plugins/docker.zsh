0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

docker_deps=(docker)

if ! zn-assert-deps $docker_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $docker_deps"
    return
fi

docker-clean() {
    docker rmi --force $(docker images -q -a) #remove all images
    docker system prune --all --volumes #clean up all volumes
}

docker-networks() {
    docker network ls $@
}

docker-rmi() {
    docker rmi $(docker images -qa)
}

docker_aliases=(
    dk docker
    dkcc docker-clean
    dkl 'docker logs'
    dkn docker-networks
    dkrmi docker-rmi
    dks 'docker stop'
    dkps 'docker ps'
)
zn-aliases $docker_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
