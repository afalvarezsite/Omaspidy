# 📋 Changelog — Omaspidy

Todos los cambios notables del proyecto se documentan aquí siguiendo el formato [Keep a Changelog](https://keepachangelog.com/es/1.1.0/) y [Versionado Semántico](https://semver.org/lang/es/).

---

## [Unreleased]

### Añadido
- **`sys-update`**: Actualizador completo del ecosistema en 5 pasos: sistema+AUR (paru), plugins Zinit, plugins Neovim/LazyVim en modo headless, Zinit self-update, y limpieza interactiva de huérfanos con fzf. Muestra tiempo total y resumen de errores. Alias: `update`.
- **`sys-record`**: Wrapper inteligente para `gpu-screen-recorder`. Control ON/OFF via PID file, notificaciones nativas (Mako) al iniciar/detener con nombre y tamaño del archivo. Soporta `--toggle`, `--start`, `--stop` y `--status`. Atajo: `Super+Alt+R`. Alias: `record`.
- **`sys-health`**: Diagnóstico del ecosistema. Comprueba 13 procesos/servicios (Hyprland, Waybar, Mako, PipeWire, hypridle, hyprpaper, SwayOSD, clipse, hyprpolkitagent, NetworkManager, bluetooth, snapper-timeline, power-profiles-daemon) y ofrece reinicio interactivo via fzf multi-select. Alias: `health`.
- **`conf.d/visual.conf`**: Secciones `general`, `decoration`, `animations` y `dwindle` extraídas de `hyprland.conf` a módulo propio.
- **`conf.d/input.conf`**: Teclado (`kb_layout = es`), ratón, touchpad (natural scroll, tap-to-click) y gestures de 3 dedos para cambiar workspace.
- **`conf.d/misc.conf`**: VFR para ahorro de batería, desactivación del splash de Hyprland, swallow de terminales (Alacritty), y DPMS wake on mouse/key.
- `gpu-screen-recorder-git` añadido a `AUR_PKGS` en `install.sh`.
- Workspaces 6-9 y sus binds de mover ventana en `keybinds.conf`.
- `sys-update`, `sys-record` y `sys-health` registrados en `sys-spidey` y `hypr-keys`.

### Cambiado
- **`hyprland.conf`**: Refactorizado como índice puro de `source =`. Ya no contiene configuración inline.
- **`sys-theme`**: Escribe `~/.cache/zsh/theme_signal.zsh` al cambiar skin para recarga live de FZF en terminales abiertas.
- **`env.zsh`**: Hook `precmd` que detecta cambios por mtime y recarga `FZF_DEFAULT_OPTS` en la sesión activa.
- **`.zshrc`**: `keychain` activado condicionalmente solo si existe una clave SSH en `~/.ssh/`.
- **`aliases.zsh`**: `update` → `sys-update`, añadidos `health` y `record`.
- **`keybinds.conf`**: `Super+Alt+R` llama a `sys-record --toggle`.
- **`install.sh`**: Eliminado `local` fuera de función en el bloque de systemd-boot.
- **`hypr-keys`**: Traducciones añadidas para todos los `sys-*` que carecían de descripción legible.
- **`dotfiles/README.md`**: Documentado con tabla de módulos Stow, comandos de despliegue, estructura de skins y referencia de scripts.

### Infraestructura
- **`.github/workflows/shellcheck.yml`**: Añadido job `stow-simulate` que detecta conflictos de symlinks en CI antes de que lleguen a la instalación real.

---

## [1.0.0] — 2026-05-29

### Lanzamiento inicial
- Instalador automatizado en dos fases (Fase 1 manual + Fase 2 vía curl).
- Entorno Hyprland con tema Spider-Man Classic + Symbiote + Miles Morales.
- Sistema de temas dinámicos con symlinks activos y recarga al vuelo.
- Configuración modular de Hyprland con `conf.d/`.
- Scripts del ecosistema: `sys-theme`, `sys-screenshot`, `sys-snaps`, `sys-replicate`, `sys-clean`, `sys-secureboot`, `sys-distrobox`, `sys-power`, `sys-wifi`, `sys-bluetooth`, `sys-audio`, `sys-share`, `sys-gemini`, `sys-sunset`, `hypr-keys`, `hypr-mirror`, `wl-ocr`, `sys-aliases`, `sys-backup`, `sys-spidey`.
- Zsh con Zinit, Starship, fzf-tab y forgit.
- Stack completo de CLI modernas en Rust/Go.
- Integración Distrobox + Podman para entornos de pruebas y pentesting.
- Soporte Secure Boot con sbctl vía `sys-secureboot`.
- Snapshots BTRFS automáticos con Snapper + snap-pac + systemd-boot-lifeboat.
- Repositorios CachyOS para binarios optimizados x86-64-v3.
