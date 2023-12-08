0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

brew_deps=(brew)

brew-help() {
    sed -e 's/^//' <<End
brew-packages list installed package versions
End
}
_plugin=${0:t:r}

if ! zn-assert-deps $brew_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $brew_deps"
    return
fi

brew-packages() {
  brew list --versions
}

brew_aliases=(
     brew-ls 'brew list'
     brew-cask 'brew list --cask'
     brew-rm 'brew remove'
     brew-up 'brew upgrade'
)
zn-aliases $brew_aliases

zn-plugin-status $(zn-plugin-name ${0}) "loaded"
