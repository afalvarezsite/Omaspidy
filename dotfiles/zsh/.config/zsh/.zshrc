# .zshrc
# Punto de entrada principal para Zsh

# Cargar configuración dividida
source "$ZDOTDIR/env.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/plugins.zsh"

# Inicializar Starship prompt
eval "$(starship init zsh)"

# Inicializar Zoxide (cd inteligente)
eval "$(zoxide init zsh)"
