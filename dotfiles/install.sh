#!/usr/bin/env bash
# ==============================================================================
# OMASPIDY: SPIDER-MAN ARCH LINUX BOOTSTRAPPER
# Instala el entorno Hyprland + CLI Rust + Tema Rojinegro desde cero.
# ==============================================================================

# --- Colores de Salida (Paleta Spider-Man Premium) ---
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

show_banner() {
  local paso="$1"
  local desc="$2"
  
  clear
  echo -e "${RED}"
  echo "  ██████╗ ███╗   ███╗ █████╗ ███████╗██████╗ ██╗██████╗ ██╗   ██╗"
  echo " ██╔═══██╗████╗ ████║██╔══██╗██╔════╝██╔══██╗██║██╔══██╗╚██╗ ██╔╝"
  echo " ██║   ██║██╔████╔██║███████║███████╗██████╔╝██║██║  ██║ ╚████╔╝ "
  echo " ██║   ██║██║╚██╔╝██║██╔══██║╚════██║██╔═══╝ ██║██║  ██║  ╚██╔╝  "
  echo " ╚██████╔╝██║ ╚═╝ ██║██║  ██║███████║██║     ██║██████╔╝   ██║   "
  echo "  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═════╝    ╚═╝   "
  echo -e "${NC}"
  echo -e "         ${BOLD}🕷️  OH MY SPIDY - Ecosistema Arch Linux Premium  🕷️${NC}"
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

msg_warn "Este script instalará todo el ecosistema (Hyprland, Drivers Intel, Zsh, Herramientas Rust, Repositorios CachyOS)."
read -p "¿Deseas continuar con la instalación? [s/N]: " confirm
if [[ ! "$confirm" =~ ^[sS]$ ]]; then
    msg "Instalación cancelada."
    exit 0
fi

# --- Clonación de Dotfiles (Soporte para ejecución vía curl) ---
DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="${REPO_URL:-https://github.com/yourusername/ArchInstallGuide.git}"

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
CORE_PKGS=(
    # Drivers Intel Meteor Lake y Hardware Base
    intel-ucode mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-utils
    sof-firmware alsa-ucm-conf thermald
    
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
    greetd greetd-tuigreet nmtui pulsemixer snapper snap-pac
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
# Limpiamos configs por defecto que puedan hacer conflicto
rm -f "$HOME/.zshrc" "$HOME/.bashrc"
rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/alacritty" "$HOME/.config/nvim"

# Entrar en la carpeta dotfiles dentro del repositorio dinámico
cd "$DOTFILES_DIR/dotfiles" || { msg_err "No se pudo acceder a la carpeta de dotfiles en $DOTFILES_DIR/dotfiles"; exit 1; }

# Hacer stow
msg "Creando symlinks..."
stow alacritty anyrun hypr mako nvim scripts starship waybar zsh git
msg_ok "Configuraciones desplegadas."

# --- 7. Habilitación de Servicios ---
show_banner "7" "Activando servicios systemd esenciales (Bluetooth, Red, Snapper)..."
msg "Habilitando servicios systemd..."
sudo systemctl enable --now thermald
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable greetd
msg_ok "Servicios activados."

# --- 7.5. Configuración de systemd-boot con Kernel CachyOS ---
show_banner "8" "Optimizando cargador de arranque systemd-boot y post-instalación..."
msg "Verificando y configurando cargador de arranque systemd-boot con linux-cachyos..."
if [ -d "/boot/loader/entries" ]; then
    # Obtener el UUID de la partición raíz montada en /
    ROOT_DEV=$(findmnt -n -o SOURCE /)
    ROOT_UUID=$(blkid -s UUID -o value "$ROOT_DEV" 2>/dev/null)
    
    if [ -n "$ROOT_UUID" ]; then
        msg "Generando entrada de boot para linux-cachyos con mitigations=off..."
        cat << EOF | sudo tee /boot/loader/entries/arch-cachyos.conf > /dev/null
title   Arch Linux (Kernel CachyOS)
linux   /vmlinuz-linux-cachyos
initrd  /intel-ucode.img
initrd  /initramfs-linux-cachyos.img
options root=UUID=$ROOT_UUID rw rootflags=subvol=@ mitigations=off intel_pstate=active
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

msg_ok "=========================================================="
msg_ok "🚀 INSTALACIÓN FINALIZADA"
msg_ok "=========================================================="
msg_ok "Tu ecosistema Arch/Hyprland 'Spider-Man' está listo."
msg_ok "La próxima vez que reinicies, verás el login de tuigreet."
msg_ok "Recuerda que Zinit instalará los plugins de zsh al abrir la terminal."
echo ""
read -p "¿Deseas reiniciar el sistema ahora? [s/N]: " reboot_confirm
if [[ "$reboot_confirm" =~ ^[sS]$ ]]; then
    systemctl reboot
fi
