export VISUAL=nvim
export EDITOR="$VISUAL"

# history in cache directory
HISTSIZE=100000000
SAVEHIST=100000000
HISTFILE=~/.cache/zsh/history

## plugins ##
source ~/.config/zsh/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen apply
PROMPT='%F{4}%? %F{1}[%F{2}%n%F{4}@%m%F{1}] %F{11}%1~ %f%# '

# creates a tmux session named as the current directory and containing two windows
function tmx {
  name="$(basename $PWD)"
  tmux new-session -d -s $name
  tmux new-window -d
  tmux attach-session -d -t $name
};

alias gS='git status'
alias ga='git add'
alias gc='git commit -v'
alias gl='git fetch && git merge --no-edit FETCH_HEAD'
alias gp='git push'

alias nv='nvim'
alias nvma='nvim Makefile'
alias py='python'

alias clock='tty-clock -s -c -f "%d.%m.%Y"'
alias textclock='~/sync/scripts/tty-qlock-1.0.0/dist/qlock -on-color green'
alias pubip='curl ifconfig.me; echo'
alias ls='ls --color'
alias l='exa -lah'
alias c='clear'
alias s='source ~/.zshrc > /dev/null 2>&1'

# linux
alias name='uname -snrmo'
alias logins='last -f /var/log/wtmp | less'

# mac
alias brew-update='brew update && brew upgrade --fetch-HEAD'
