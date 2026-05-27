# plugins.zsh
# Configuración y carga de plugins de Zsh

# Aquí se asumiría un gestor de plugins como zinit, zplug, antogen, o instalación manual.
# Para esta configuración base, si se instalan vía AUR (Arch), se encuentran en /usr/share/zsh/plugins/

# Ejemplo cargando desde paquetes estándar de Arch/AUR:
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-sudo/sudo.plugin.zsh 2>/dev/null
# source /usr/share/zsh/plugins/zsh-extract/extract.plugin.zsh 2>/dev/null # A menudo se incluye con oh-my-zsh

# Forgit (si está instalado en un path local)
# source ~/.local/share/forgit/forgit.plugin.zsh 2>/dev/null

# FZF tab
source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh 2>/dev/null

# Inicializar keychain para SSH/GPG
eval $(keychain --eval --quiet)
