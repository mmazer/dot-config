# list subdirectories in current directory and change to selected directory
fzf-subdir() {
  local dir=$(fd --max-depth 1 --type d . | fzf)
  [[ -n "dir" ]] && cd "$dir"
}
