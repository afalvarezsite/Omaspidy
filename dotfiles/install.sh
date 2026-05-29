#!/usr/bin/env bash
# ==============================================================================
# OMASPIDY: SPIDER-MAN ARCH LINUX BOOTSTRAPPER
# Instala el entorno Hyprland + CLI Rust + Tema Rojinegro desde cero.
# ==============================================================================

# --- Configuración defensiva y manejo de errores ---
set -Euo pipefail

# --- Colores de Salida (Paleta Spider-Man) ---
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

msg() { echo -e "${BLUE}::${NC} $1"; }
msg_ok() { echo -e "${GREEN}==>${NC} $1"; }
msg_err() { echo -e "${RED}[ERROR]${NC} $1"; }
msg_warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

failure_trap() {
  local lineno="$1"
  local code="$2"
  msg_err "¡Fallo crítico en la línea $lineno del script (Código de salida: $code)!"
  msg_err "El script de instalación se ha detenido para proteger la integridad del sistema."
  exit "$code"
}
trap 'failure_trap $LINENO $?' ERR

show_banner() {
  local paso="${1:-}"
  local desc="${2:-}"
  
  clear
  echo -e "${RED}"
  echo "  ██████╗ ███╗   ███╗ █████╗ ███████╗██████╗ ██╗██████╗ ██╗   ██╗"
  echo " ██╔═══██╗████╗ ████║██╔══██╗██╔════╝██╔══██╗██║██╔══██╗╚██╗ ██╔╝"
  echo " ██║   ██║██╔████╔██║███████║███████╗██████╔╝██║██║  ██║ ╚████╔╝ "
  echo " ██║   ██║██║╚██╔╝██║██╔══██║╚════██║██╔═══╝ ██║██║  ██║  ╚██╔╝  "
  echo " ╚██████╔╝██║ ╚═╝ ██║██║  ██║███████║██║     ██║██████╔╝   ██║   "
  echo "  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═════╝    ╚═╝   "
  echo -e "${NC}"
  echo -e "         ${BOLD}  OH MY SPIDY - Ecosistema Arch Linux  ${NC}"
  echo -e "     ${WHITE}─────────────────────────────────────────────────────────${NC}"
  
  if [ -n "$paso" ] && [ -n "$desc" ]; then
    echo ""
    echo -e "  ${RED}[ PASO $paso / 8 ]${NC} ${BOLD}$desc${NC}"
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────${NC}"
  fi
  echo ""
}

# --- Comprobación de Seguridad ---
if [ "$EUID" -eq 0 ]; then
  msg_err "¡No ejecutes este script como root! Ejecútalo con tu usuario normal."
  msg_err "Paru/Makepkg no pueden funcionar como root. El script pedirá sudo cuando lo necesite."
  exit 1
fi

# Mostrar banner de presentación inicial
show_banner "" ""

msg_warn "Este script instalará todo el ecosistema (Hyprland, Drivers Intel/AMD, Zsh, Herramientas Rust, Repositorios CachyOS)."
read -p "¿Deseas continuar con la instalación? [s/N]: " confirm
if [[ ! "$confirm" =~ ^[sS]$ ]]; then
    msg "Instalación cancelada."
    exit 0
fi

# --- Detección y Configuración de Hardware ---
CPU_BRAND="Generic"
if grep -q "AuthenticAMD" /proc/cpuinfo; then
    CPU_BRAND="AMD"
elif grep -q "GenuineIntel" /proc/cpuinfo; then
    CPU_BRAND="Intel"
fi

msg "Detección de CPU: Se ha detectado un procesador $CPU_BRAND."

INSTALL_INTEL_OPT=false
if [ "$CPU_BRAND" = "Intel" ]; then
    read -p "¿Deseas aplicar las optimizaciones ultra-específicas para Intel Meteor Lake (intel-ucode, thermald, active P-state scaling, intel-media-driver)? [S/n]: " opt_intel
    if [[ ! "$opt_intel" =~ ^[nN]$ ]]; then
        INSTALL_INTEL_OPT=true
    fi
else
    read -p "¿Deseas forzar la instalación de las optimizaciones para procesadores/gráficos Intel Meteor Lake? [s/N]: " opt_intel
    if [[ "$opt_intel" =~ ^[sS]$ ]]; then
        INSTALL_INTEL_OPT=true
    fi
fi


# --- Clonación de Dotfiles (Soporte para ejecución vía curl) ---
DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="${REPO_URL:-https://github.com/afalvarezsite/Omaspidy.git}"

# Comprobar si estamos ejecutando localmente desde un repositorio existente
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
if [ -d "$CURRENT_DIR/../.git" ] || [ -d "$CURRENT_DIR/.git" ]; then
    if [ -d "$CURRENT_DIR/../.git" ]; then
        DOTFILES_DIR="$(cd "$CURRENT_DIR/.." && pwd)"
    else
        DOTFILES_DIR="$CURRENT_DIR"
    fi
    msg_ok "Detección local: Ejecutando desde $DOTFILES_DIR"
else
    # Si no es local, necesitamos clonar el repositorio
    msg "Detección remota: Preparando clonación de dotfiles..."
    if ! command -v git &> /dev/null; then
        msg "Instalando Git temporalmente..."
        sudo pacman -S --needed --noconfirm git || { msg_err "Error al instalar Git"; exit 1; }
    fi
    
    if [ ! -d "$DOTFILES_DIR" ]; then
        msg "Clonando repositorio de dotfiles en $DOTFILES_DIR..."
        git clone "$REPO_URL" "$DOTFILES_DIR" || { msg_err "Error al clonar el repositorio"; exit 1; }
    else
        msg "El directorio $DOTFILES_DIR ya existe. Actualizando..."
        cd "$DOTFILES_DIR" && git pull || msg_warn "No se pudo actualizar el repositorio local."
    fi
fi

# --- 1. Sincronización base y Paru ---
show_banner "1" "Configurando repositorios CachyOS, actualizando e instalando Paru..."
msg "Pidiendo permisos de administrador para la instalación inicial..."

# Configuración de los repositorios optimizados de CachyOS e instalación del Kernel
msg "Configurando repositorios optimizados de CachyOS (soporte precompilado x86-64-v3)..."
curl -sSL https://ross.cachyos.org/cachyos-repo.sh | sudo bash || { msg_err "Error al configurar repositorios de CachyOS"; exit 1; }

msg "Actualizando librerías del sistema al nivel de instrucciones óptimo de tu CPU..."
sudo pacman -Syu --noconfirm || { msg_err "Error actualizando el sistema"; exit 1; }

# Instalar dependencias para compilar Paru e instalar el kernel optimizado
sudo pacman -S --needed --noconfirm base-devel git curl wget linux-cachyos linux-cachyos-headers || { msg_err "Error al instalar dependencias base y kernel"; exit 1; }

if ! command -v paru &> /dev/null; then
    msg "Instalando Paru (AUR Helper)..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru || exit
    makepkg -si --noconfirm
    cd - || exit
    rm -rf /tmp/paru
    msg_ok "Paru instalado."
else
    msg_ok "Paru ya está instalado."
fi

# --- 2. Paquetes Base (Repositorios Oficiales) ---
show_banner "2" "Instalando paquetes base del repositorio oficial de Arch Linux..."
msg "Instalando paquetes del repositorio oficial de Arch..."

HW_PKGS=()
if [ "$INSTALL_INTEL_OPT" = true ]; then
    msg_ok "Optimizaciones específicas de Intel Meteor Lake activadas."
    HW_PKGS=(
        intel-ucode mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-utils
        sof-firmware alsa-ucm-conf thermald
    )
else
    msg "Configurando soporte de hardware genérico/compatible..."
    # Mesa es esencial para la mayoría de GPUs
    HW_PKGS+=(mesa)
    
    if [ "$CPU_BRAND" = "Intel" ]; then
        HW_PKGS+=(intel-ucode vulkan-intel lib32-vulkan-intel)
    elif [ "$CPU_BRAND" = "AMD" ]; then
        HW_PKGS+=(amd-ucode vulkan-radeon lib32-vulkan-radeon)
    else
        # Fallback seguro
        HW_PKGS+=(intel-ucode amd-ucode)
    fi
fi

CORE_PKGS=(
    "${HW_PKGS[@]}"
    
    # Entorno Gráfico (Wayland/Hyprland)
    hyprland hyprpaper hyprlock hypridle waybar mako
    
    # Audio y Redes
    pipewire pipewire-pulse pipewire-alsa wireplumber
    networkmanager bluez bluez-utils
    
    # TUI, Terminal y Shell
    alacritty zsh stow fzf starship yazi
    
    # CLI Modernos (Rust/Go)
    zoxide eza bat ripgrep fd btop procs dust duf git-delta tealdeer
    
    # Utilidades Varias y Fuentes
    neovim ttf-hack-nerd wl-clipboard tesseract tesseract-data-spa grim slurp satty
    greetd greetd-tuigreet nmtui pulsemixer snapper snap-pac power-profiles-daemon hyprsunset sbctl
    
    # Contenedores y Aislamiento (Pruebas y Pentesting)
    distrobox podman
    
    # Nuevas Herramientas Optimizadas (Rust/Go/C)
    fastfetch gdu xh jaq lazygit mise trippy bandwhich
)

paru -S --needed --noconfirm "${CORE_PKGS[@]}"

# --- 3. Paquetes AUR (-git y específicos) ---
show_banner "3" "Instalando herramientas y utilidades adicionales desde AUR..."
msg "Instalando paquetes de AUR..."
AUR_PKGS=(
    anyrun-git
    swayosd-git
    hyprpolkitagent-git
    clipse
    bluetuith-bin
    systemd-boot-lifeboat
    localsend-go-bin
    oxker-bin
    antigravity-cli
    bibata-cursor-theme
    zen-browser-bin
)

paru -S --needed --noconfirm "${AUR_PKGS[@]}"

# --- 4. Configuración del Greetd (Login TUI) ---
show_banner "4" "Configurando gestor de login visual (greetd + tuigreet)..."
msg "Configurando greetd (tuigreet) con tema Spider-Man..."
sudo mkdir -p /etc/greetd
cat << 'EOF' | sudo tee /etc/greetd/config.toml > /dev/null
[terminal]
vt = 1

[default_session]
# Lanzamos tuigreet con la estetica rojo y negro, apuntando directamente a Hyprland
command = "tuigreet --cmd Hyprland --asterisks --time --theme 'border=red;text=white;prompt=red;time=white;action=red;button=red;container=black;input=red'"
user = "greeter"
EOF
sudo usermod -aG video greeter

# --- 5. Configuración de Snapper y Backups Automáticos ---
show_banner "5" "Configurando políticas de backups y snapshots automáticos BTRFS..."
msg "Configurando Snapshots automáticos de BTRFS..."

if [ "$(findmnt -n -o FSTYPE /)" = "btrfs" ]; then
    msg "Sistema de archivos BTRFS detectado. Validando estructura de snapper..."
    if [ -d "/.snapshots" ]; then
        if ! sudo btrfs subvolume show /.snapshots &>/dev/null; then
            msg_warn "/.snapshots existe como directorio normal. Convirtiéndolo a subvolumen BTRFS para evitar snapshots recursivos..."
            sudo mv /.snapshots /.snapshots_old_backup 2>/dev/null
            sudo btrfs subvolume create /.snapshots
            sudo rm -rf /.snapshots_old_backup
        fi
    else
        sudo btrfs subvolume create /.snapshots
    fi
    msg_ok "Subvolumen /.snapshots verificado y listo."
fi

if [[ ! -f /etc/snapper/configs/root ]]; then
    sudo snapper -c root create-config / || msg_warn "Snapper config 'root' ya existe o hubo un error."
    
    # Aplicar limites estrictos para no llenar el disco duro
    msg "Aplicando limites de retención de Snapshots..."
    sudo snapper -c root set-config NUMBER_LIMIT=10
    sudo snapper -c root set-config NUMBER_LIMIT_IMPORTANT=5
    sudo snapper -c root set-config TIMELINE_LIMIT_HOURLY=5
    sudo snapper -c root set-config TIMELINE_LIMIT_DAILY=7
    sudo snapper -c root set-config TIMELINE_LIMIT_WEEKLY=0
    sudo snapper -c root set-config TIMELINE_LIMIT_MONTHLY=0
    sudo snapper -c root set-config TIMELINE_LIMIT_YEARLY=0
fi
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# --- 6. Configuración de Dotfiles (Stow) ---
show_banner "6" "Enlazando configuraciones personales de tus dotfiles con Stow..."
msg "Desplegando configuraciones con Stow..."
# Limpiamos configs por defecto que puedan hacer conflicto de forma no destructiva (Respaldando)
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%s)"
msg_backup=false

for item in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/alacritty" "$HOME/.config/nvim" "$HOME/.config/antigravity" "$HOME/.config/fastfetch" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/theme"; do
    if [ -e "$item" ] || [ -L "$item" ]; then
        if [ "$msg_backup" = false ]; then
            msg "Se han detectado configuraciones previas en tu sistema."
            msg "Creando respaldos de seguridad en: $BACKUP_DIR"
            mkdir -p "$BACKUP_DIR"
            msg_backup=true
        fi
        # Si es un symlink (ej. Stow de una instalacion previa), se borra directamente
        if [ -L "$item" ]; then
            rm -f "$item"
        else
            mv "$item" "$BACKUP_DIR/"
        fi
    fi
done

# Entrar en la carpeta dotfiles dentro del repositorio dinámico
cd "$DOTFILES_DIR/dotfiles" || { msg_err "No se pudo acceder a la carpeta de dotfiles en $DOTFILES_DIR/dotfiles"; exit 1; }

# Hacer stow
msg "Creando symlinks..."
stow alacritty anyrun hypr mako nvim scripts starship waybar zsh git antigravity lazygit bat fastfetch gtk theme
msg_ok "Configuraciones desplegadas."

# --- 7. Habilitación de Servicios ---
show_banner "7" "Activando servicios systemd esenciales e integrando Podman..."
msg "Habilitando servicios systemd..."
if [ "$INSTALL_INTEL_OPT" = true ]; then
    sudo systemctl enable --now thermald
fi
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now power-profiles-daemon
sudo systemctl enable greetd
sudo systemctl enable systemd-boot-lifeboat.timer
msg_ok "Servicios activados."

# Configuración de Podman rootless (mapeo de subuids/subgids)
msg "Verificando configuración de Podman rootless para el usuario..."
if ! grep -q "^$USER:" /etc/subuid 2>/dev/null || ! grep -q "^$USER:" /etc/subgid 2>/dev/null; then
    msg "Configurando rangos de subuids/subgids para contenedores rootless..."
    # Asignar un rango estándar de UIDs/GIDs si no están ya configurados (estándar: 100000-165535)
    sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER" || {
        msg_warn "No se pudieron configurar automáticamente los subuids/subgids. Si tienes problemas con podman, ejecuta manualmente: sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER"
    }
    msg_ok "Mapeos de subuid y subgid configurados para el usuario $USER."
else
    msg_ok "Mapeos de subuid y subgid ya existentes para el usuario $USER."
fi

# --- 7.2. Verificación de Antigravity-CLI ---
msg "Verificando instalación de Antigravity-CLI..."
if command -v antigravity &> /dev/null; then
    msg_ok "Antigravity-CLI se encuentra instalado en el sistema."
else
    msg_warn "Antigravity-CLI no se ha detectado. Asegúrate de que se instaló correctamente desde el AUR."
fi

# --- 7.5. Configuración de systemd-boot con Kernel CachyOS ---
show_banner "8" "Optimizando cargador de arranque systemd-boot y post-instalación..."
msg "Verificando y configurando cargador de arranque systemd-boot con linux-cachyos..."
if [ -d "/boot/loader/entries" ]; then
    # Obtener el UUID de la partición raíz montada en /
    ROOT_DEV=$(findmnt -n -o SOURCE /)
    ROOT_UUID=$(blkid -s UUID -o value "$ROOT_DEV" 2>/dev/null)
    
    if [ -n "$ROOT_UUID" ]; then
        msg "Generando entrada de boot para linux-cachyos con mitigations=off..."
        
        local ucode_initrd=""
        if [ "$INSTALL_INTEL_OPT" = true ] || [ "$CPU_BRAND" = "Intel" ]; then
            ucode_initrd="initrd  /intel-ucode.img"
        elif [ "$CPU_BRAND" = "AMD" ]; then
            ucode_initrd="initrd  /amd-ucode.img"
        fi

        local kernel_options="root=UUID=$ROOT_UUID rw rootflags=subvol=@ mitigations=off"
        if [ "$INSTALL_INTEL_OPT" = true ]; then
            kernel_options="$kernel_options intel_pstate=active"
        fi

        cat << EOF | sudo tee /boot/loader/entries/arch-cachyos.conf > /dev/null
title   Arch Linux (Kernel CachyOS)
linux   /vmlinuz-linux-cachyos
${ucode_initrd:+$ucode_initrd
}initrd  /initramfs-linux-cachyos.img
options $kernel_options
EOF
        # Establecer la entrada cachyos por defecto
        sudo sed -i 's/^default.*/default arch-cachyos.conf/' /boot/loader/loader.conf 2>/dev/null || \
        echo "default arch-cachyos.conf" | sudo tee -a /boot/loader/loader.conf >/dev/null
        msg_ok "Entrada de arranque cachyos generada y configurada por defecto."
    else
        msg_warn "No se pudo determinar el UUID de la partición raíz. Por favor, configura tu cargador de arranque manualmente."
    fi
else
    msg_warn "Directorio de systemd-boot (/boot/loader/entries) no encontrado. Asegúrate de configurar tu cargador manualmente."
fi

# --- 8. Post-Instalación ---
msg "Cambiando la shell por defecto a Zsh..."
chsh -s "$(which zsh)"

# Optimizar almacenamiento de cursores (mantener solo Bibata-Modern-Ice)
msg "Optimizando almacenamiento de cursores (manteniendo solo Bibata-Modern-Ice)..."
for theme in Bibata-Modern-Amber Bibata-Modern-Amber-Right Bibata-Modern-Classic Bibata-Modern-Classic-Right Bibata-Modern-Ice-Right Bibata-Original-Amber Bibata-Original-Amber-Right Bibata-Original-Classic Bibata-Original-Classic-Right Bibata-Original-Ice Bibata-Original-Ice-Right; do
    if [ -d "/usr/share/icons/$theme" ]; then
        sudo rm -rf "/usr/share/icons/$theme"
    fi
done
msg_ok "Limpieza de cursores finalizada. Solo se conserva Bibata-Modern-Ice."

# --- 8.5. Limpieza y Optimización del Sistema (Entorno Ultra Ligero) ---
msg "Iniciando limpieza profunda del sistema para mantener un entorno ultra ligero..."

# 1. Eliminar paquetes huérfanos residuales (instalados como dependencias de compilación de AUR que ya no se necesitan)
msg "Buscando y eliminando paquetes huérfanos (make-dependencies sobrantes)..."
ORPHANS=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$ORPHANS" ]; then
    sudo pacman -Rns --noconfirm $ORPHANS
    msg_ok "Paquetes huérfanos eliminados con éxito."
else
    msg "No se encontraron paquetes huérfanos que eliminar."
fi

# 2. Limpiar completamente la caché de descargas de pacman
msg "Vaciando caché de paquetes descargados de Pacman para liberar espacio en disco..."
sudo pacman -Scc --noconfirm
if command -v paccache &> /dev/null; then
    sudo paccache -r -k 0 &>/dev/null
fi

# 3. Limpiar la caché de descargas de AUR (paru)
msg "Limpiando la caché de compilaciones de Paru (AUR)..."
if command -v paru &> /dev/null; then
    paru -Sc --noconfirm
fi
rm -rf "$HOME/.cache/paru/clone/"* 2>/dev/null

# 4. Reducir y limitar los registros (logs) de systemd journal a un máximo de 50MB
msg "Optimizando y limitando el tamaño del log del sistema (systemd journal)..."
sudo journalctl --vacuum-size=50M
# Configurar límite permanente en journald.conf para evitar crecimiento futuro
if [ -f "/etc/systemd/journald.conf" ]; then
    sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=50M/' /etc/systemd/journald.conf 2>/dev/null || \
    echo "SystemMaxUse=50M" | sudo tee -a /etc/systemd/journald.conf >/dev/null
    sudo systemctl restart systemd-journald 2>/dev/null
fi

# 5. Configurar Zen Browser como navegador por defecto para HTTP y HTTPS
msg "Configurando Zen Browser como tu navegador web por defecto..."
xdg-settings set default-web-browser zen-browser.desktop 2>/dev/null || true
xdg-mime default zen-browser.desktop x-scheme-handler/http 2>/dev/null || true
xdg-mime default zen-browser.desktop x-scheme-handler/https 2>/dev/null || true

msg_ok "Optimización y limpieza profunda del sistema finalizada."

msg_ok "=========================================================="
msg_ok "  INSTALACIÓN FINALIZADA"
msg_ok "=========================================================="
msg_ok "Tu ecosistema Arch/Hyprland 'Spider-Man' está listo."
msg_ok "La próxima vez que reinicies, verás el login de tuigreet."
msg_ok "Recuerda que Zinit instalará los plugins de zsh al abrir la terminal."
echo ""
echo -e "${YELLOW}:: AVISO GEMINI / COPILOT KEY:${NC}"
echo -e "   Para aprovechar al máximo el atajo de la tecla Copilot (SUPER + SHIFT + F23) y"
echo -e "   evitar pestañas duplicadas de Gemini, recuerda instalar la extensión"
echo -e "   'Duplicate Tab Blocker' o 'Switch to Existing Tab' en Zen Browser."
echo ""
read -p "¿Deseas reiniciar el sistema ahora? [s/N]: " reboot_confirm
if [[ "$reboot_confirm" =~ ^[sS]$ ]]; then
    systemctl reboot
fi
