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
export PATH="$PATH:$HOME/.local/bin"

# ==============================================================================
# CONFIGURACIÓN DE FORGIT (TEMA SPIDER-MAN DISCRETO)
# ==============================================================================
# Opciones personalizadas de fzf para forgit (colores y diseño redondeado)
export FORGIT_FZF_DEFAULT_OPTS="
  --color='fg:7,bg:-1,hl:9'
  --color='fg+:15,bg+:8,hl+:9'
  --color='info:8,prompt:9,pointer:12,marker:12,spinner:12,header:8'
  --layout='reverse'
  --border='rounded'
"

# Historial
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# ==============================================================================
# CARGA DE SKIN DE TEMA DINÁMICO (Ecosistema Spidey)
# ==============================================================================
if [ -f "$HOME/.config/theme/active.sh" ]; then
    source "$HOME/.config/theme/active.sh"
    # Exportar la configuración de colores fzf global del tema
    export FZF_DEFAULT_OPTS="--layout=reverse --border=rounded --padding=1,2 --margin=2% --prompt=' ❯ ' --pointer='' --marker='󰄬' $FZF_THEME"
fi

# Recarga dinámica de colores FZF cuando sys-theme cambia la skin al vuelo
# sys-theme escribe en este archivo de señal; el hook precmd lo recarga en cada prompt
_ZSH_THEME_SIGNAL="$HOME/.cache/zsh/theme_signal.zsh"
_reload_theme_if_changed() {
    if [[ -f "$_ZSH_THEME_SIGNAL" ]]; then
        local _mtime
        _mtime=$(stat -c %Y "$_ZSH_THEME_SIGNAL" 2>/dev/null)
        if [[ "$_mtime" != "${_LAST_THEME_MTIME:-}" ]]; then
            _LAST_THEME_MTIME="$_mtime"
            source "$_ZSH_THEME_SIGNAL"
        fi
    fi
}
# Añadir al hook precmd (se ejecuta justo antes de mostrar cada prompt)
autoload -Uz add-zsh-hook
add-zsh-hook precmd _reload_theme_if_changed
