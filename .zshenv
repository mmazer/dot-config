# load common shell environment
[[ -f "$HOME/.config/shell/env" ]] && source "$HOME/.config/shell/env"

# load local environment
[[ -f "$HOME/.local/zsh/.zshenv" ]] && source "$HOME/.local/zsh/.zshenv"
