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

autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b) '
setopt PROMPT_SUBST

#PROMPT='%n in ${PWD/#$HOME/~} ${vcs_info_msg_0_}%% '
PROMPT='%(?..[%?] )%{$fg[red]%}[%{$fg[green]%}%n%{$fg[red]%}@%{$fg[blue]%}%m%{$fg[red]%}] %{$fg[yellow]%}%~ %{$fg[cyan]%}${vcs_info_msg_0_}%{$reset_color%}%% '

# creates a tmux session named as the current directory and containing two windows
function tmx {
  name="$(basename "$PWD")"
  tmux new-session -d -s "$name"
  tmux new-window -d
  tmux attach-session -d -t "$name"
}

alias gg='git status'
alias gr='git grep'
alias gd='watch --color -n5 git diff --color=always'
alias ga='git add'
alias gc='git commit -v'
alias gp='git fetch && git merge --no-edit FETCH_HEAD'
alias gP='git push'
alias gu='git fetch && git merge --no-edit FETCH_HEAD && git push'
alias lg='lazygit'

countdown() {
  start="$(( $(date +%s) + $1))"
  while [ "$start" -ge $(date +%s) ]; do
    ## Is this more than 24h away?
    days="$(($(($(( $start - $(date +%s) )) * 1 )) / 86400))"
    time="$(( $start - `date +%s` ))"
    printf '%s day(s) and %s\r' "$days" "$(date -u -r "$time" +%H:%M:%S)"
    sleep 0.1
  done
}

stopwatch() {
  start=$(date +%s)
  while true; do
    days="$(($(( $(date +%s) - $start )) / 86400))"
    time="$(( $(date +%s) - $start ))"
    printf '%s day(s) and %s\r' "$days" "$(date -u -r "$time" +%H:%M:%S)"
    sleep 0.1
  done
}

alias nv='nvim'
alias py='python3'
alias jn='jupyter notebook'

case "$(uname -s)" in
  Linux*)     alias fm='thunar . &';;
  Darwin*)    alias fm='open .';;
esac

alias clock='tty-clock -s -c -f "%m/%d/%Y"'
alias pubip='curl ifconfig.me; echo'
alias wttr='curl wttr.in'
alias wthr='curl wttr.in/?format="%r+%C+%t(%f)+%h+%w\n" > ~/.cache/weather; cat ~/.cache/weather'
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

if command_exists fastfetch; then
  alias f='fastfetch'
else
  alias f='neofetch'
fi

# linux
alias name='uname -snrmo'
alias logins='last -f /var/log/wtmp | less'

# mac
unalias brew-update 2>/dev/null || true
brew-update() {
  echo "==> Updating Homebrew metadata…"
  brew update

  echo "==> Upgrading all formulae…"
  brew upgrade --formula

  echo "==> Upgrading all casks (including greedy)…"
  brew upgrade --cask --greedy

  echo "==> Cleaning up old versions…"
  brew autoremove
  brew cleanup -s

  echo "==> Doctor check…"
  brew doctor || true

  echo "==> Outdated after upgrade (should be none):"
  brew outdated || true
}
if [[ -f ~/.zprofile ]]; then source ~/.zprofile; fi
[[ ! -r /Users/connor/.opam/opam-init/init.zsh ]] || source /Users/connor/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# Detect home directory properly
home="$HOME"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('${home}/.local/share/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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

if command_exists thefuck; then
    eval "$(thefuck --alias)"
fi

if command_exists opam; then
    eval $(opam env)
fi
