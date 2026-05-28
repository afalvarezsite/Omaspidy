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
if command -v keychain &> /dev/null; then
    eval $(keychain --eval --quiet)
fi
