# env.zsh
# Variables de entorno y configuraciones de ruta

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BROWSER="firefox"

# Exportar variables para XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Añadir binarios locales y de Cargo al PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Historial
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
