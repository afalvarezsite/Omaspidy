# 📦 Módulos de Dotfiles — Omaspidy

Este directorio contiene todos los módulos de configuración gestionados con **[GNU Stow](https://www.gnu.org/software/stow/)**.

Cada subdirectorio es un módulo independiente. `stow <módulo>` crea symlinks en `$HOME` replicando la estructura interna del módulo.

---

## 🗂️ Estructura de Módulos

| Módulo | Destino en `$HOME` | Descripción |
|---|---|---|
| `alacritty/` | `~/.config/alacritty/` | Configuración del emulador de terminal |
| `antigravity/` | `~/.config/antigravity/` | Configuración del asistente de IA |
| `anyrun/` | `~/.config/anyrun/` | Configuración del lanzador de aplicaciones |
| `bat/` | `~/.config/bat/` | Tema y configuración de `bat` (reemplazo de `cat`) |
| `fastfetch/` | `~/.config/fastfetch/` | Configuración del fetcher de sistema |
| `git/` | `~/.config/git/` | Configuración global de Git |
| `gtk/` | `~/.config/gtk-3.0/`, `~/.config/gtk-4.0/` | Tema GTK (cursor, iconos, fuentes) |
| `hypr/` | `~/.config/hypr/` | Configuración completa de Hyprland + hypridle + hyprlock + hyprpaper |
| `lazygit/` | `~/.config/lazygit/` | Configuración del cliente Git TUI |
| `mako/` | `~/.config/mako/` | Configuración del demonio de notificaciones |
| `nvim/` | `~/.config/nvim/` | Configuración de Neovim / LazyVim |
| `scripts/` | `~/.local/bin/` | Scripts personalizados `sys-*` y `hypr-*` |
| `starship/` | `~/.config/starship.toml` | Configuración del prompt Starship |
| `theme/` | `~/.config/theme/` | Sistema de temas dinámicos: skins y symlinks activos |
| `waybar/` | `~/.config/waybar/` | Configuración y estilos de la barra de estado |
| `yazi/` | `~/.config/yazi/` | Configuración del gestor de archivos TUI |
| `zsh/` | `~/.config/zsh/`, `~/.zshenv` | Configuración modular de Zsh + plugins Zinit |

---

## 🚀 Despliegue Manual

```bash
# Desplegar todos los módulos de una vez
cd dotfiles/
stow alacritty anyrun bat fastfetch git gtk hypr lazygit \
     mako nvim scripts starship theme waybar yazi zsh antigravity

# Desplegar un módulo individual
stow hypr

# Retirar un módulo (elimina sus symlinks)
stow -D hypr

# Simular sin aplicar cambios (verificación previa)
stow --simulate hypr
```

---

## 🎨 Sistema de Temas Dinámicos

Las skins del ecosistema viven en `theme/.config/theme/skins/`. Cada skin consta de 5 archivos:

```
skins/
├── classic_spidey.conf          # Variables de color para Hyprland
├── classic_spidey.css           # Variables CSS para Waybar
├── classic_spidey.sh            # Variables de entorno para FZF y scripts
├── classic_spidey_mako.conf     # Configuración de Mako (notificaciones)
└── classic_spidey_starship.toml # Tema del prompt Starship
```

Para cambiar de tema: ejecuta `sys-theme` o presiona `Super + M` para abrir el Centro de Control.

---

## 🛠️ Scripts del Ecosistema (`scripts/.local/bin/`)

| Script | Atajo | Descripción |
|---|---|---|
| `sys-spidey` | `Super+M` | Centro de control general |
| `sys-theme` | vía sys-spidey | Selector de skins dinámico |
| `sys-update` | `update` | Actualización completa del ecosistema |
| `sys-health` | `health` | Diagnóstico de servicios del entorno |
| `sys-record` | `Super+Alt+R` | Grabador de pantalla con VA-API |
| `sys-screenshot` | `Print` | Captura de pantalla temática |
| `sys-snaps` | `Super+Shift+S` | Gestión de snapshots BTRFS |
| `sys-replicate` | vía sys-spidey | Backup incremental a USB externo |
| `sys-clean` | vía sys-spidey | Limpieza de huérfanos y caché |
| `sys-secureboot` | `Super+Shift+U` | Asistente de Secure Boot (sbctl) |
| `sys-distrobox` | `dbs` | Gestor de contenedores TUI |
| `hypr-keys` | `Super+G` | Guía interactiva de atajos |
| `wl-ocr` | `Super+T` | Captura de pantalla a texto (OCR) |


Este directorio contiene las configuraciones específicas de las aplicaciones gestionadas e instaladas con `stow` (incluyendo el nuevo módulo centralizado `theme` para la gestión de Skins).

👉 Para ver la **Guía Completa de Instalación del Sistema** (Fase 1 y Fase 2), consulta el [README.md principal en la raíz de este repositorio](../README.md).
