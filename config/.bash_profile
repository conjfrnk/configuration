export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR='nvim'
export CLICOLOR=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_SESSION_TYPE=wayland 
export GDK_BACKEND=wayland

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

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    dbus-run-session sway
fi

type -p gnome-command-daemon > /dev/null && gnome-keyring-daemon -r -d
