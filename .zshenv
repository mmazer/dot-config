# load common shell environment
[[ -f "$HOME/.config/shell/env" ]] && source "$HOME/.config/shell/env"

# load local environment
[[ -f "$HOME/.local/share/zsh/.zshenv" ]] && source "$HOME/.local/share/zsh/.zshenv"
