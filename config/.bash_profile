export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR='nvim'
export CLICOLOR=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"

[ -d ~/torch ] && . ~/torch/install/bin/torch-activate
[ -f $HOME/.local/flutter/version ] && export PATH=$PATH:$HOME/.local/flutter/bin
export PATH=$PATH:$GOPATH/bin:$HOME/.local/bin

if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" == 1 ]; then
    exec startx
fi

#type -p gnome-command-daemon > /dev/null && gnome-keyring-daemon -r -d
