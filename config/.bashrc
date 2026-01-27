unameOut="$(uname -s)"

command_exists () {
    type "$1" &> /dev/null ;
}

if command_exists nvim; then
    export VISUAL='nvim'
else
    export VISUAL='vim'
fi
export EDITOR="$VISUAL"

HISTSIZE=10000
SAVEHIST=10000

# Color Codes
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
CYAN='\[\e[36m\]'
RESET='\[\e[0m\]'

# Function to capture the last exit status
capture_exit_status() {
    LAST_EXIT="$?"
}

# Update PROMPT_COMMAND to capture exit status and set terminal title
PROMPT_COMMAND='capture_exit_status; echo -en "\033]0;[${USER}@${HOSTNAME}] ${PWD##*/} $(parse_git_branch)\a"'

# Function to get Git branch info
parse_git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        echo "($branch) "
    fi
}

# Build the PS1 prompt
PS1='$(if [ $LAST_EXIT -ne 0 ]; then echo "[${LAST_EXIT}] "; fi)'
PS1+="${RED}[${GREEN}\u${RED}@${BLUE}\h${RED}] "
PS1+="${YELLOW}\w "
PS1+="${CYAN}\$(parse_git_branch)"
PS1+="${RESET}% "

# creates a tmux session named as the current directory and containing two windows
function tmx {
    name="$(basename "$PWD")"
    tmux new-session -d -s "$name"
    tmux new-window -d
    tmux attach-session -d -t "$name"
}

countdown() {
    start="$(( $(date +%s) + $1))"
    while [ "$start" -ge $(date +%s) ]; do
        ## Is this more than 24h away?
        days="$(($(($(( $start - $(date +%s) )) * 1 )) / 86400))"
        time="$(( $start - `date +%s` ))"
        if [[ "$unameOut" == "Darwin" ]]; then
            printf '%s day(s) and %s\r' "$days" "$(date -u -r "$time" +%H:%M:%S)"
        else
            printf '%s day(s) and %s\r' "$days" "$(date -u -d "@$time" +%H:%M:%S)"
        fi
        sleep 0.1
    done
}

stopwatch() {
    start=$(date +%s)
    while true; do
        days="$(($(( $(date +%s) - $start )) / 86400))"
        time="$(( $(date +%s) - $start ))"
        if [[ "$unameOut" == "Darwin" ]]; then
            printf '%s day(s) and %s\r' "$days" "$(date -u -r "$time" +%H:%M:%S)"
        else
            printf '%s day(s) and %s\r' "$days" "$(date -u -d "@$time" +%H:%M:%S)"
        fi
        sleep 0.1
    done
}

if command_exists nproc; then
    alias make='make -j$(nproc)'
elif [[ "$unameOut" == "Darwin" ]]; then
    alias make='make -j$(sysctl -n hw.ncpu)'
fi

alias gg='git status'
alias gr='git grep'
alias gd='watch --color -n5 git diff --color=always'
alias ga='git add'
alias gc='git commit -v'
alias gp='git fetch && git merge --no-edit FETCH_HEAD'
alias gP='git push'
alias gu='git fetch && git merge --no-edit FETCH_HEAD && git push'
alias lg='lazygit'

# Wrap opencode to set tmux window name
opencode() {
    if [ -n "$TMUX" ]; then
        tmux rename-window 'opencode'
        command opencode "$@"
        tmux set-window-option automatic-rename on
    else
        command opencode "$@"
    fi
}

# Wrap claude to set tmux window name
claude() {
    if [ -n "$TMUX" ]; then
        tmux rename-window 'claude'
        command claude "$@"
        tmux set-window-option automatic-rename on
    else
        command claude "$@"
    fi
}

alias nv='nvim'
alias py='python3'
alias jn='jupyter notebook'

case "${unameOut}" in
    Linux*)     alias fm='thunar . &';;
    Darwin*)    alias fm='open .';;
esac

alias clock='tty-clock -s -c -f "%m/%d/%Y"'
alias pubip='curl ifconfig.me; echo'
alias wttr='curl wttr.in'
alias wthr='curl wttr.in/?format="%r+%C+%t(%f)+%h+%w\n" > ~/.cache/weather; cat ~/.cache/weather'
alias watch='watch --color'

if command_exists eza; then
    alias l='eza -lah'
else
    alias l='ls -lah'
fi
alias t='tree -C'

alias c='clear'
alias s='source ~/.bashrc > /dev/null 2>&1'

if command_exists fastfetch; then
    alias f='fastfetch'
else
    alias f='neofetch'
fi

# linux
alias name='uname -snrmo'
alias logins='last -f /var/log/wtmp | less'

# mac
alias brew-update='brew update && brew upgrade --fetch-HEAD'

[ -f '/etc/profile.d/bash_completion.sh' ] && source '/etc/profile.d/bash_completion.sh'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/.miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
if command_exists conda; then
    conda activate base
fi

if command_exists thefuck; then
    eval "$(thefuck --alias)"
fi

if command_exists opam; then
    eval $(opam env)
fi

alias claude="/home/connor/.claude/local/claude"
