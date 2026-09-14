export EDITOR=nvim
export LD_LIBRARY_PATH="/usr/local/cuda-12/lib64:$LD_LIBRARY_PATH"
export PROJECT=$HOME/Desktop/Project/
export DOTFILES="$HOME/dotfiles/dotfiles"
export WALLPAPERS="$HOME/Downloads/livewall/"
export TERM=xterm-256color
export GTK_THEME=Adwaita:dark
export PATH="$PATH:$FLYCTL_INSTALL/bin"
alias mux="tmux attach 2>/dev/null || tmux"
alias prime-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
