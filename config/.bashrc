command_exists () {
    type "$1" &> /dev/null ;
}

if command_exists nvim; then
    export VISUAL='vim'
else
    export VISUAL='vim'
fi
export EDITOR="$VISUAL"

HISTSIZE=10000
SAVEHIST=10000

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

export PS1="\[\e[31m\][\[\e[32m\]\u\[\e[31m\]@\[\e[34m\]\h\[\e[31m\]] \[\e[33m\]\W \[\e[0m\]\$ "
PS1="\[\e[31m\][\[\e[32m\]\u\[\e[31m\]@\[\e[34m\]\h\[\e[31m\]] \[\e[33m\]\W \[\e[35m\]\$(parse_git_branch)\[\e[0m\]\$ "
PROMPT_COMMAND='echo -en "\033]0;[$(whoami)@$(uname -n)] $(basename $(pwd)) $(parse_git_branch)\a"'

# creates a tmux session named as the current directory and containing two windows
function tmx {
    name="$(basename $PWD)"
    tmux new-session -d -s $name
    tmux new-window -d
    tmux attach-session -d -t $name
};

countdown() {
    start="$(( $(date +%s) + $1))"
    while [ "$start" -ge $(date +%s) ]; do
        ## Is this more than 24h away?
        days="$(($(($(( $start - $(date +%s) )) * 1 )) / 86400))"
        time="$(( $start - `date +%s` ))"
        printf '%s day(s) and %s\r' "$days" "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 0.1
    done
}

stopwatch() {
    start=$(date +%s)
    while true; do
        days="$(($(( $(date +%s) - $start )) / 86400))"
        time="$(( $(date +%s) - $start ))"
        printf '%s day(s) and %s\r' "$days" "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 0.1
    done
}

alias gg='git status'
alias gr='git grep'
alias gd='watch --color -n5 git diff --color=always'
alias ga='git add'
alias gc='git commit -v'
alias gp='git fetch && git merge --no-edit FETCH_HEAD'
alias gP='git push'

alias nv='nvim'
alias py='python3'
alias jn='jupyter notebook'

alias clock='tty-clock -s -c -f "%m/%d/%Y"'
alias pubip='curl ifconfig.me; echo'
alias watch='watch --color'

if command_exists exa; then
    alias l='exa -lah'
else
    alias l='ls -lah'
fi

alias c='clear'
alias s='source ~/.bashrc > /dev/null 2>&1'

# linux
alias name='uname -snrmo'
alias logins='last -f /var/log/wtmp | less'

# mac
alias brew-update='brew update && brew upgrade --fetch-HEAD'

[ -f '/etc/profile.d/bash_completion.sh' ] && source '/etc/profile.d/bash_completion.sh'

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     home='/home/connor';;
    Darwin*)    home='/Users/connor';;
esac

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('${home}/.local/share/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${home}/.local/share/miniconda3/etc/profile.d/conda.sh" ]; then
        . "${home}/.local/share/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="${home}/.local/share/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
if command_exists conda; then
    conda activate base
fi
