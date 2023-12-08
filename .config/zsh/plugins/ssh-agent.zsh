0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# https://help.github.com/articles/working-with-ssh-key-passphrases
# Note: ~/.ssh/environment should not be used, as it
#       already has a different purpose in SSH.

if [[ ! -o interactive ]]; then
    return
fi

env=~/.ssh/agent.env

# Note: Don't bother checking SSH_AGENT_PID. It's not used
#       by SSH itself, and it might even be incorrect
#       (for example, when using agent-forwarding over SSH).

ssh-agent-running() {
    if [ "$SSH_AUTH_SOCK" ]; then
        # ssh-add returns:
        #   0 = agent running, has keys
        #   1 = agent running, no keys
        #   2 = agent not running
        ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
    else
        false
    fi
}

agent_has_keys() {
    ssh-add -l >/dev/null 2>&1
}

agent_load_env() {
    . "$env" >/dev/null
}

agent_start() {
    (umask 077; ssh-agent >"$env")
    . "$env" >/dev/null
}

if ! ssh-agent-running; then
    agent_load_env
fi

if ! ssh-agent-running; then
    agent_start
    ssh-add
elif ! agent_has_keys; then
    ssh-add
fi

unset env agent_has_keys agent_load_env agent_start

ssh_agent_aliases=(
    ssh-agent-reload 'source ${ZSH_CONFIG_HOME}/plugins/ssh-agent.zsh'
    ssh-agent-check '[[ ssh-agent-running ]] && echo "ssh-agent is running"'
)
zn-aliases $ssh_agent_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
