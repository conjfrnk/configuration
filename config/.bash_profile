export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR='nvim'
export CLICOLOR=1

# Add Homebrew to PATH on macOS (before system paths so brew vim is preferred)
if [ "$(uname -s)" == "Darwin" ] && [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Wayland environment variables (Linux only)
if [ "$(uname -s)" == "Linux" ]; then
    export XDG_SESSION_TYPE=wayland
    export GDK_BACKEND=wayland
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
fi

export LESSHISTFILE="-"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"

[ -d $HOME/torch ] && . ~/torch/install/bin/torch-activate
[ -f $HOME/.local/flutter/version ] && export PATH=$PATH:$HOME/.local/flutter/bin
[ -d $HOME/.local/share/cargo/bin ] && export PATH=$PATH:$HOME/.local/share/cargo/bin
export PATH=$PATH:$GOPATH/bin:$HOME/.local/bin

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

if [ "$(uname -s)" == "Linux" ]; then
    if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
        #export WLR_DRM_DEVICES=$(realpath /dev/dri/by-path/pci-0000:00:02.0-card)
        #export WLR_NO_HARDWARE_CURSORS=1
        #export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
        #export __GLX_VENDOR_LIBRARY_NAME=mesa
        #exec dbus-run-session sway --unsupported-gpu "$@"
        export WLR_DRM_DEVICES=/dev/dri/card0
        exec dbus-run-session sway
    fi
fi

type -p gnome-keyring-daemon > /dev/null && gnome-keyring-daemon -r -d

# opam configuration
test -r ~/.opam/opam-init/init.sh && . ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
