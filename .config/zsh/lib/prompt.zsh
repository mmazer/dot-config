zn-run-precmd() {
    local precmd
      for precmd in $precmd_functions; do
        $precmd
      done
}

zn-reset-prompt() {
    zn-run-precmd
    zle reset-prompt
}
