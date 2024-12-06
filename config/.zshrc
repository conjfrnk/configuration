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

#PROMPT='%n in ${PWD/#$HOME/~} ${vcs_info_msg_0_}%% '
PROMPT='%(?..[%?] )%{$fg[red]%}[%{$fg[green]%}%n%{$fg[red]%}@%{$fg[blue]%}%m%{$fg[red]%}] %{$fg[yellow]%}%~ %{$fg[cyan]%}${vcs_info_msg_0_}%{$reset_color%}%% '

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
alias gu='git fetch && git merge --no-edit FETCH_HEAD && git push'
alias lg='lazygit'

alias nv='nvim'
alias py='~/.miniconda3/bin/python'
alias jn='jupyter notebook'

alias clock='tty-clock -s -c -f "%m/%d/%Y"'
alias pubip='curl ifconfig.me; echo'
alias watch='watch --color'
alias grep='grep --color'

if command_exists eza; then
  alias l='eza -lah'
else
  alias l='ls -lah'
fi
alias t='tree -C'

alias c='clear'
alias s='source ~/.zshrc > /dev/null 2>&1'

# linux
alias name='uname -snrmo'
alias logins='last -f /var/log/wtmp | less'

# mac
alias brew-update='brew update && brew upgrade --fetch-HEAD'
if [[ -f ~/.zprofile ]] then; source ~/.zprofile; fi
[[ ! -r /Users/connor/.opam/opam-init/init.zsh ]] || source /Users/connor/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

if command_exists opam; then
    eval $(opam env)
fi
