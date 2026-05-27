# aliases.zsh
# Alias y reemplazos modernos de CLI

# Navegación y utilidades básicas
alias c="clear"
alias q="exit"
alias mkdir="mkdir -p"

# Modern CLI Replacements (Tools_utils_other.md)
alias ls="eza --icons=always --color=always --group-directories-first"
alias ll="eza -al --icons=always --color=always --group-directories-first"
alias lt="eza --tree --level=2 --icons=always --color=always"

alias cat="bat --style=plain"
alias grep="rg"
alias find="fd"
alias du="dust"
alias df="duf"
alias top="btop"
alias ps="procs"
alias man="tldr"

# Git (muchos otros alias se manejan mediante la configuración de git o plugins de zsh)
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"

# Utilidades de sistema
alias update="paru -Syu"
alias sys-backup="sudo lifeboat" # Wrapper o uso directo de systemd-boot-lifeboat
