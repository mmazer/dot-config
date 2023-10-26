# checkout git branch
fzf-git-checkout() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# git commit browser
fzf-git-commits() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

#  fuzzy find git files and open in editor
fzf-git-edit() {
  local files file
  files=$(git ls-files) &&
  file=$(echo "$files" | fzf +s) &&
  [[ -n "$file" ]] && ${EDITOR:-nvim} "${file}"
}

# get git commit sha
fzf-git-sha() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  print "$commit" | awk '{printf "%s\n", $1 }'
}

alias ggb=fzf-git-checkout
alias ggl='git last'
alias ggm='git checkout main'
alias ggpl='git pull origin'
alias ggs='git status'
