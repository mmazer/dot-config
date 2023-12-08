0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

git_deps=(git fzf)
if ! zn-assert-deps $git_deps; then
    zn-plugin-status $(zn-plugin-name "$0") "missing one of $git_deps"
    return
fi

git-is-repo() {
    local dir=${1:-$(pwd)}
    git -C ${dir} rev-parse 2> /dev/null
}

git-file-history() {
    local file=${1:?"file path required"}
    git log --all --full-history -- "$file"
}

# checkout git branch
fzf-git-checkout() {
    if ! git-is-repo; then
        printf "not a git repository (or any parent dirs)"
        return 1
    fi
    local branches branch
    branches=$(git branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# git commit browser
fzf-git-commits() {
    if ! git-is-repo; then
        printf "not a git repository (or any parent dirs)"
        return 1
    fi
    PREVIEW_CMD="(grep -o '[a-f0-9]\{7\}' | head -1 |
        xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
    FZF-EOF"
    git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf -e --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
    --preview "$PREVIEW_CMD" \
    --bind "ctrl-q:abort" \
    --bind "ctrl-y:execute(echo {} | sed '/^$/d' | \
        grep -o '[a-f0-9]\{7\}' | head -1 | xclip -r -selection clipboard)" \
    --bind "ctrl-m:execute: $PREVIEW_CMD"
}

# git stash browser
fzf-git-stashes() {
    if ! git-is-repo; then
        printf "not a git repository (or any parent dirs)"
        return 1
    fi
    FZF_DEFAULT_COMMAND="git stash list" \
        fzf --preview "echo {} | cut -d':' -f1 | xargs git stash show -p" \
            --bind "ctrl-a:execute:echo {} | cut -d':' -f1 | xargs git stash apply" \
            --bind "ctrl-m:execute:echo {} | cut -d':' -f1 | xargs git stash pop" \
            --bind "ctrl-m:+abort" \
            --bind "ctrl-d:execute:echo {} | cut -d':' -f1 | xargs git stash drop" \
            --bind "ctrl-d:+reload(git stash list)"

}

#  fuzzy find git files and open in editor
fzf-git-edit() {
    if ! git-is-repo; then
        printf "not a git repository (or any parent dirs)"
        return 1
    fi
    local files file
    files=$(git ls-files) &&
    file=$(echo "$files" | fzf +s) &&
    [[ -n "$file" ]] && ${EDITOR:-nvim} "${file}"
}

# get git commit sha
fzf-git-sha() {
    if ! git-is-repo; then
        printf "not a git repository (or any parent dirs)"
        return 1
    fi
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
    print "$commit" | awk '{printf "%s\n", $1 }'
}

git_aliases=(
     gga 'git add'
     ggbr 'git branches'
     ggc 'git checkout'
     ggcb 'git checkout -b'
     ggci 'git commit'
     ggd 'git diff'
     ggdir 'cd `git rev-parse --git-dir`; cd ..'
     ggfh 'git log --all --full-history'
     ggh 'git hist'
     ggl 'git last'
     ggm 'git checkout main'
     ggpl 'git pull origin'
     ggplr 'git pull --rebase origin'
     ggps 'git push origin'
     ggs 'git status'
     ggsh 'git show'
     ggsp 'git stash pop'
     ggst fzf-git-stashes
     ggb fzf-git-checkout
     ggc fzf-git-commits
     gge fzf-git-edit
)
zn-aliases $git_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
