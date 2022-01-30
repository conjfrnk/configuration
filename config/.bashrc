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

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

export PS1="\[\e[31m\][\[\e[32m\]\u\[\e[34m\]@\h\[\e[31m\]] \[\e[33m\]\W \[\e[0m\]\$ "
PS1="\[\e[31m\][\[\e[32m\]\u\[\e[34m\]@\h\[\e[31m\]] \[\e[33m\]\W \[\e[35m\]\$(parse_git_branch)\[\e[0m\]\$ "

# creates a tmux session named as the current directory and containing two windows
function tmx {
  name="$(basename $PWD)"
  tmux new-session -d -s $name
  tmux new-window -d
  tmux attach-session -d -t $name
};

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

alias clock='tty-clock -s -c -f "%d.%m.%Y"'
alias pubip='curl ifconfig.me; echo'
alias ls='ls --color'
alias watch='watch --color'

if command_exists exa; then
  alias l='exa -lah'
else
  alias l='ls -lah --color'
fi

alias c='clear'
alias s='source ~/.bashrc > /dev/null 2>&1'

# linux
alias name='uname -snrmo'
alias logins='last -f /var/log/wtmp | less'

# mac
alias brew-update='brew update && brew upgrade --fetch-HEAD'

[ -f '/etc/profile.d/bash_completion.sh' ] && source '/etc/profile.d/bash_completion.sh'
