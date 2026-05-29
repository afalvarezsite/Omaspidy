# .zshrc
# Punto de entrada principal para Zsh

# Cargar configuracion modular
source "$ZDOTDIR/env.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/plugins.zsh"

# Inicializar Zoxide (cd inteligente)
eval "$(zoxide init zsh)"

# Inicializar Mise (Gestor de versiones políglota en Rust)
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

# Inicializar Starship prompt (Cargar al final para no ralentizar plugins)
eval "$(starship init zsh)"

# Llavero SSH y GPG seguro (Mantiene la contraseña entre terminales)
# Solo activa keychain si existe al menos una clave SSH
if command -v keychain &>/dev/null; then
    _ssh_key=""
    for _k in id_ed25519 id_rsa id_ecdsa; do
        [[ -f "$HOME/.ssh/$_k" ]] && { _ssh_key="$_k"; break; }
    done
    if [[ -n "$_ssh_key" ]]; then
        eval "$(keychain --eval --quiet "$_ssh_key")"
    fi
    unset _ssh_key _k
fi
