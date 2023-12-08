0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

github_deps=(gh)
if ! zn-assert-deps $github_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $github_deps"
    return
fi

github_aliases=(
    ghc 'gh issue close'
    ghcc 'gh issue comment'
    ghd  'gh issue delete'
    ghe 'gh issue edit'
    ghi 'gh issue'
    ghim 'gh search issues --assignee=@me --state="open" --limit 50'
    ghl 'gh issue list'
    ghla 'gh issue list -s all'
    ghp 'gh pr'
    ghpm 'gh search prs --author=@me --state="open"'
    ghs 'gh search'
    ghsp 'gh search prs'
    ghv 'gh issue view'
    ghw 'gh repo view --web'
)
zn-aliases $github_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
