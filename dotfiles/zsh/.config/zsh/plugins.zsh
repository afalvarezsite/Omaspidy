# plugins.zsh
# Gestor de Plugins ultra-rápido: Zinit

# Directorio de instalación de zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Instalar Zinit automáticamente si no se encuentra en el sistema
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Iniciar Zinit
source "${ZINIT_HOME}/zinit.zsh"

# --- Plugins Puros Asíncronos ---
# Autocompletado rápido
zinit light zsh-users/zsh-autosuggestions
# Resaltado de sintaxis (se carga el último para no interferir)
zinit light zsh-users/zsh-syntax-highlighting

# fzf-tab (Reemplaza el autocompletado tabulador por defecto por fzf)
zinit light Aloxaf/fzf-tab

# forgit (Utilidad interactiva fzf para git)
zinit light wfxr/forgit

# --- Snippets de Oh-My-Zsh ---
# sudo: Pulsa ESC dos veces para añadir 'sudo' al inicio del comando
zinit snippet OMZP::sudo
# extract: Extrae cualquier archivo sin pensar en el formato (x x.tar.gz)
zinit snippet OMZP::extract
# git: Cientos de alias y utilidades para git
zinit snippet OMZP::git

# --- Configuración específica de plugins ---
# Asegurar compatibilidad de fzf-tab con colores personalizados (Spider-Man theme)
zstyle ':fzf-tab:*' fzf-flags \
    --color="bg+:#16171f,bg:#0c0d12,spinner:#ff3b5c,hl:#00e5ff" \
    --color="fg:#f8f9fa,header:#ff3b5c,info:#d500f9,pointer:#00e676" \
    --color="marker:#e60026,fg+:#ffffff,prompt:#e60026,hl+:#00e5ff,border:#ff1e43"
zstyle ':fzf-tab:*' fzf-pad 4
