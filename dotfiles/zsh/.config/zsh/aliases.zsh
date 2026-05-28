# aliases.zsh
# Alias y reemplazos modernos de la CLI (Escritos en Rust/Go)

# --- Navegacion Básica ---
alias c="clear"
alias q="exit"
alias mkdir="mkdir -p"

# --- Modern CLI Replacements ---
# ls -> eza (Mejor color y estructura)
alias ls="eza --icons=always --color=always --group-directories-first"
alias ll="eza -al --icons=always --color=always --group-directories-first"
alias lt="eza --tree --level=2 --icons=always --color=always"

# cat -> bat (Cat con resaltado de sintaxis)
alias cat="bat --style=plain"

# grep -> ripgrep (Búsqueda ultra-rápida)
alias grep="rg"

# find -> fd (Búsqueda amigable)
alias find="fd"

# du -> dust (Analizador de espacio visual)
alias du="dust"

# df -> duf (Espacio en disco visual)
alias df="duf"

# ps -> procs (Monitor de procesos moderno)
alias ps="procs"

# top/htop -> btop (Monitor de recursos interactivo)
alias top="btop"
alias htop="btop"

# diff -> delta (Visor de diferencias para git/diff)
alias diff="delta"

# man -> tealdeer (Páginas man con ejemplos cortos)
alias man="tldr"

# --- Git & Forgit ---
# Utilizar las interfaces interactivas de forgit en lugar de los comandos estandar
alias g="git"
alias gs="git status"
alias ga='forgit::add'
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd='forgit::diff'
alias glo='forgit::log'
alias gcb='forgit::checkout::branch'

# --- Mantenimiento Arch ---
alias update="paru -Syu"
alias orphans="pacman -Qtdq"

# --- Distrobox y Podman (Entornos Contenedorizados de Pruebas y Pentesting) ---
alias db="distrobox"
alias dbl="distrobox list"
alias dbe="distrobox enter"
alias dbr="distrobox rm"
alias dbc="distrobox create"
alias dbs="sys-distrobox"  # Lanzador interactivo TUI con fzf
alias kali="distrobox enter kali-pentest"
alias ubuntu="distrobox enter ubuntu-test"
alias archbox="distrobox enter arch-test"

# --- Nuevos Reemplazos Modernos y Usabilidad (Rust/Go/C) ---
alias neofetch="fastfetch"                   # Reemplazo de neofetch por fastfetch en C
alias fetch="fastfetch"                      # Atajo rápido para información del sistema
alias jq="jaq"                               # Reemplazo en Rust de jq para análisis de JSON
alias http="xh"                              # Cliente HTTP interactivo y veloz
alias lg="lazygit"                           # La TUI definitiva de Git
alias traceroute="trip"                      # Reemplazo interactivo de traceroute por Trippy
alias bandwidth="sudo bandwhich"             # Monitor de ancho de banda por proceso (requiere sudo)
