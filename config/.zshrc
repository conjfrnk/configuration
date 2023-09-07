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

autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b) '
setopt PROMPT_SUBST

PROMPT='%n in ${PWD/#$HOME/~} ${vcs_info_msg_0_}%% '
PROMPT='%{$fg[red]%}[%{$fg[green]%}%n%{$fg[red]%}@%{$fg[blue]%}%m%{$fg[red]%}] %{$fg[yellow]%}%~ %{$fg[cyan]%}${vcs_info_msg_0_}%{$reset_color%}%% '

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

alias clock='tty-clock -s -c -f "%m/%d/%Y"'
alias pubip='curl ifconfig.me; echo'
alias watch='watch --color'
alias grep='grep --color'

if command_exists exa; then
  alias l='exa -lah'
else
  alias l='ls -lah'
fi

alias c='clear'
alias s='source ~/.zshrc > /dev/null 2>&1'

# linux
alias name='uname -snrmo'
alias logins='last -f /var/log/wtmp | less'

# mac
alias brew-update='brew update && brew upgrade --fetch-HEAD'

export PATH="~/.config/emacs/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/connor/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/connor/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/connor/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/connor/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export PATH="~/.config/emacs/bin:$PATH"
