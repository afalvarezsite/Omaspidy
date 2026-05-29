# My Arch Linux Setup & Tooling Guide

A personal reference guide for my preferred configurations, system components, and CLI tools.

## 🖥️ Core System
- **Base:** Arch Linux
- **Kernel:** linux-cachyos
- **File System:** BTRFS
- **Bootloader:** **systemd-boot** with **UKI (Unified Kernel Images)** (Fast, modern, and highly optimized boot setup; configured with **`mitigations=off`** in kernel parameters for maximum CPU throughput)
- **Audio Server:** PipeWire (with `pipewire-pulse`, `pipewire-alsa`, and `wireplumber` for modern audio and video routing)

## ⚙️ Hardware & Driver Optimization (Intel Meteor Lake Platform)
Specifically tailored and optimized for the **Intel Core Ultra 7 155H** + **Intel Arc Graphics** architecture:
- **Processor Microcode:** `intel-ucode` (Essential security and stability microcode patches for Intel Core Ultra)
- **Graphics Drivers (Mesa):**
  - **OpenGL/Vulkan:** `mesa` + `vulkan-intel` + `lib32-vulkan-intel` (High performance userspace driver for Arc Graphics/Xe-LPG)
  - **Kernel Driver:** El kernel oficial usa el driver `i915` por defecto o el nuevo driver de alto rendimiento `xe` (diseñado específicamente desde cero para arquitecturas Xe-HPG/Xe-LPG como Intel Arc en Meteor Lake). En el kernel `linux-cachyos` ya viene completamente soportado y optimizado de forma nativa.
    > [!TIP]
    > **Cómo forzar el driver `xe` de alto rendimiento para exprimir tus gráficos al máximo (Intel Arc):**
    > 1. Crea el archivo de configuración de modprobe `/etc/modprobe.d/xe.conf`:
    >    ```ini
    >    options i915 force_probe=!7d05
    >    options xe force_probe=7d05
    >    ```
    >    *(Nota: `7d05` es el ID PCI típico para la gráfica integrada Intel Arc Xe-LPG del Core Ultra 7 155H. Asegúrate de verificar tu ID ejecutando `lspci -nn | grep VGA`)*.
    > 2. Regenera tu initramfs para aplicar el cambio en el arranque:
    >    ```bash
    >    sudo mkinitcpio -P
    >    ```
- **Hardware Video Acceleration:** `intel-media-driver` + `libva-utils` (Enables full hardware AV1, H.265/HEVC, VP9, and H.264 video decoding/encoding)
- **Audio Firmware:** `sof-firmware` + `alsa-ucm-conf` (Crucial for Intel Smart Sound Technology to recognize internal microphones and speakers)
- **Thermal & Hybrid Core Management:**
  - `thermald` (Intel daemon to prevent thermal throttling and manage Intel Dynamic Tuning)
  - Hybrid Core scheduling is handled natively by the kernel (Intel Thread Director) and optimized by the `linux-cachyos` scheduler
- **Pure Performance Tuning:** Add **`mitigations=off`** (Reclaims up to 15-20% CPU performance by disabling CPU security mitigations) and **`intel_pstate=active`** (Enables active P-State scaling for Intel CPUs) to the kernel parameters
- **NVMe & BTRFS Optimization:** Mount BTRFS partition with `noatime,ssd,discard=async,compress=zstd:1` (Asynchronous TRIM and ultra-fast zstd compression to minimize disk I/O bottlenecks and boost read/write speeds for DRAM-less Lexar SSDs)

## 🎨 Desktop Environment
- **Window Manager:** Hyprland
- **Terminal:** Alacritty
- **Shell:** Zsh
- **Login Manager:** greetd + tuigreet
- **Status Bar:** Waybar
- **App Launcher:** **Anyrun** (Ultra-minimalist, fast application runner and launcher written in **Rust**; configured strictly with **`libapplications.so`** to only search/launch `.desktop` applications and eliminate all redundant features)
- **Polkit Agent:** **hyprpolkitagent** (Official Hyprland Polkit authentication agent for privilege elevation)
- **Notification Daemon:** **mako** (Lightweight, fast, and highly customizable Wayland-native notification daemon)
- **Screen Locker:** **hyprlock** (Fast, secure, and beautiful official Hyprland screen locker)
- **Idle Manager:** **hypridle** (Official, highly optimized system idle management daemon)
- **Wallpaper Daemon:** **hyprpaper** (Official, GPU-accelerated, ultra-lightweight wallpaper utility)
- **Screenshot Tool:** **grim** + **slurp** + **hyprpicker** paired with **satty** (A modern, blazing-fast Rust-based screenshot editor with beautiful annotations and clipboard-first workflow)
- **Screen Recorder:** **gpu-screen-recorder** (Screamingly fast GPU-accelerated screen recorder with virtually 0% CPU impact, using Intel VA-API for zero-latency 60FPS recordings on Intel Arc)
- **On-Screen Display (OSD):** **SwayOSD** (A modern, blazing-fast OSD daemon written in **Rust** using GTK4 to show beautiful, lightweight volume and brightness indicators on keypresses)



## 🔤 Typography & Fonts
- **Main Font:** **Hack Nerd Font** (or **JetBrains Mono NL Nerd Font**)
  - *Note:* Clean, highly readable monospaced coding fonts with **no ligatures** by design/configuration, fully patched with rich glyph support for icons in Waybar and Starship.

## 📝 Text Editor & IDE
- **Editor:** Neovim configured with **LazyVim** (A pre-configured, modern, extensible, and blazing fast terminal IDE)
- **AI Pair Programmer:** **Antigravity** (Powerful agentic AI coding assistant)
  - **IDE Integration:** For smart code completions, contextual pair programming, and direct edits in Neovim.
  - **CLI Tool:** For launching autonomous coding tasks, terminal executions, and agentic workflows from the shell.
- **Git TUI Client:** **lazygit** (The ultimate Go-based interactive Git TUI, integrated seamlessly into the terminal and LazyVim development workflow; aliased to `lg`)
- **Version Manager:** **mise** (Screamingly fast, Rust-based polyglot tool version manager, automatically loading runtime environments)

## 🛠️ Essential Utilities & System Management
- **File Manager (CLI):** Yazi
- **Fuzzy Finder:** fzf
- **System Backups:** Snapper + snap-pac + **systemd-boot-lifeboat** (Automated BTRFS snapshots with automatic boot entries in systemd-boot for easy system rollback/recovery)
- **Backlight Control:** **brightnessctl** (Lightweight, permission-safe CLI tool for screen and keyboard backlight)
- **Screen Temperature (Blue Light):** **hyprsunset** (Official Hyprland application to adjust screen temperature / blue light filter)
- **AUR Helper:** **paru** (Feature-rich, blazing fast Arch User Repository helper written in **Rust** for beautiful and safe package building)
- **Containerized Environments:** **distrobox** + **podman** (Highly optimized tool to run any Linux distribution inside a container seamlessly integrated with your host's Wayland, PipeWire, and GPU acceleration; keeps the host Arch system 100% clean and pristine)
  - **Interactive CLI Manager:** **sys-distrobox** (A custom-built Spider-Man themed TUI helper using `fzf` for launching, creating, upgrading, exporting applications, and managing containers in a unified, beautiful CLI interface)
  - **Quick Shell Aliases:**
    - `dbs` ➡️ Launch the interactive manager (`sys-distrobox`)
    - `kali` ➡️ Enter the **Kali Pentesting Box** directly
    - `ubuntu` ➡️ Enter the **Ubuntu Test Box** directly
    - `archbox` ➡️ Enter the **Arch Linux Test Box** directly

## 📟 Optimized TUI & System Services
The most optimized, fast, and community-preferred Terminal User Interfaces (TUI):
- **Network Management:** **NetworkManager** managed via **nmtui** (The standard, robust terminal UI for Wi-Fi and connections)
- **Bluetooth Management:** **bluez** managed via **bluetuith** (Modern, sleek Rust-based TUI) or **bluetoothctl** (Classic interactive tool)
- **Audio Control:** **pulsemixer** (Beautiful and intuitive interactive terminal mixer for PipeWire/PulseAudio)
- **Clipboard History:** **wl-clipboard** + **clipse** (Gorgeous, ultra-optimized Go-based 100% TUI clipboard manager. Perfect for launching in a floating Alacritty window in Hyprland, acting exactly like the `Win + V` history menu)
- **Credential Manager:** **gopass** (*Optional* - Modern, Go-based evolution of the classic UNIX `pass` password manager for local/Git-first setups)

## 🚀 Modern CLI Replacements
Upgrades for standard Unix commands to improve productivity and UX:
- `cd` ➡️ **zoxide** (Smarter directory navigation)
- `ls` ➡️ **eza** (Modern replacement for ls, formerly `exa`)
- `cat` ➡️ **bat** (Cat clone with syntax highlighting)
- `grep` ➡️ **ripgrep** (Extremely fast search)
- `find` ➡️ **fd** (Simple, fast and user-friendly find alternative)
- `htop` ➡️ **btop** (Beautiful resource monitor)
- `ps` ➡️ **procs** (Modern replacement for ps)
- `du` ➡️ **dust** (More intuitive version of du)
- `df` ➡️ **duf** (Disk Usage/Free Utility)
- `diff` ➡️ **delta** (A viewer for git and diff output)
- `man` ➡️ **tealdeer** (Screamingly fast Rust implementation of `tldr` for practical command examples instead of huge man pages)
- `neofetch` ➡️ **fastfetch** (Hyper-fast system information fetcher written in C; aliased to `fetch` / `neofetch`)
- `jq` ➡️ **jaq** (Rust-based extremely fast, correct, and secure clone of jq; aliased to `jq`)
- `curl` ➡️ **xh** (Blazing fast, modern, and beautiful HTTP request tool in Rust; aliased to `http`)
- `ncdu` ➡️ **gdu** (Go-based highly concurrent, extremely fast interactive disk usage analyzer)
- **trippy** (Highly interactive traceroute and ping TUI in Rust; aliased to `traceroute`)
- **bandwhich** (Real-time network usage and bandwidth monitor sorted by process/port in Rust; aliased to `bandwidth`)

## 🐚 Zsh Configuration
My essential Zsh plugins for a better terminal experience:
- **autosuggestions:** Fast, unobtrusive as-you-type autocomplete
- **zsh-syntax-highlighting:** Highlights commands as they are typed
- **sudo:** Quickly prefix the current command with sudo (usually by pressing ESC twice)
- **extract:** Easily extract any archive format
- **git:** Numerous useful git aliases
- **forgit:** Utility tool powered by fzf for using git interactively
- **starship:** Ultra-fast, customizable, cross-shell Rust prompt
- **keychain:** Standard manager for `ssh-agent` and `gpg-agent` (Prompts for SSH/GPG passphrases only once per boot and shares agents across all terminal instances)
- **fzf-tab:** Zsh plugin that replaces the default tab-completion menu with a beautiful interactive **fzf** window for searching/selecting paths and arguments

---

## 📦 Distrobox & Podman Containerization Guide
A powerful, zero-overhead workflow using rootless Podman containers to run test setups, development nodes, and pentesting utilities without polluting the host Arch Linux OS.

### 🚀 Key Features
- **System Isolation:** Host system remains 100% pristine.
- **Deep Integration:** Automatic sharing of:
  - **Wayland / X11** display servers (run GUI programs like Wireshark or Burp Suite seamlessly).
  - **PipeWire** audio channels.
  - **GPU acceleration** (Intel Arc graphics Xe-LPG cores).
  - **Home Directory:** Host files are natively accessible at `$HOME` inside the container.

### 🎮 The `sys-distrobox` CLI Manager
Instead of writing long commands, use the interactive TUI tool `sys-distrobox` (aliased to `dbs`):
- Run `dbs` to open the custom fzf-powered menu.
- **Podman Container Monitor:** **oxker** (Rust-based lightweight TUI monitor for containers, natively integrated and launchable directly from the `dbs` main menu).
- **Predefined environments:**
  1. `kali-pentest` (`kali`): Kali Linux container ready for auditing.
  2. `ubuntu-test` (`ubuntu`): Standard Ubuntu testing playground.
  3. `arch-test` (`archbox`): Secondary Arch Linux environment.

###   Kali Pentesting Integration
To fully initialize the security auditing environment:
1. Launch `kali` or select it in `dbs`.
2. Once inside, install the base pentesting suite:
   ```bash
   sudo apt update && sudo apt install -y kali-linux-headless
   ```
3. Run GUI auditing tools natively, e.g., `wireshark` or `burpsuite`.

### 󱠟 Exporting Applications to Host
You can export apps or scripts from any container so they can be launched directly from your host terminal or `anyrun` app launcher:
- **Graphical App:** `distrobox-export --app wireshark` (exposes Wireshark in Hyprland launchers)
- **CLI Binary:** `distrobox-export --bin nmap` (symlinks `nmap` inside `~/.local/bin/nmap` on the host)
- *Note:* Our `dbs` manager has a built-in helper menu to do this for you!


## 󰦃  Secure Boot & UKI Signing (sbctl Guide)
To protect your kernel and initramfs from boot-level manipulation, we implement custom Secure Boot signing using **`sbctl`** (a user-friendly, modern tool to manage UEFI keys) and our interactive manager **`sys-secureboot`**.

### 󰃬  1. Put your UEFI into "Setup Mode"
To allow the OS to register custom Secure Boot keys, you must first clear the factory default keys in your motherboard's firmware:
1. Reboot your system and enter your BIOS/UEFI settings (typically pressing `F2`, `Del` or `F12` during boot).
2. Navigate to the **Security** or **Boot** tab and locate the **Secure Boot** section.
3. If Secure Boot is enabled, **disable it** temporarily.
4. Locate the option to change the Key Management type from *Standard* to **Custom**, or select **"Clear Secure Boot Keys"** / **"Reset to Setup Mode"**.
   - *Note:* This puts the system into **Setup Mode**, allowing it to accept custom OS keys.
5. Save your changes and boot back into your Arch Linux system.

### 󰌆  2. Run the `sys-secureboot` Wizard
Instead of manually typing long commands, launch our custom interactive wizard:
```bash
sudo sys-secureboot
```
*(This tool is located inside your stowed dotfiles at `~/.local/bin/sys-secureboot`)*.

The wizard provides a clean, step-by-step TUI driven by `fzf` to:
1. **Verify Status:** Checks if your UEFI is correctly in **Setup Mode** (ready to receive keys).
2. **Generate Keys:** Automatically generates your custom signature keys under `/usr/share/secureboot/`.
3. **Enrol Keys:** Registers your new keys into the UEFI NVRAM. 
   > [!IMPORTANT]
   > We run `sbctl enroll-keys -m` to **include Microsoft keys**. This is highly critical to prevent motherboard option ROM blockouts (e.g. from external graphics cards or screens) and allow stable dual-boot environments.
4. **Sign Bootloader & UKI:** Automatically detects and signs:
   - Systemd-boot bootloader (`/boot/EFI/systemd/systemd-bootx64.efi`)
   - Fallback loader (`/boot/EFI/BOOT/BOOTX64.EFI`)
   - Your Unified Kernel Image (`/boot/EFI/Linux/arch-linux-cachyos.efi`)
   - *Note:* The script uses `sbctl sign -s` which **saves** the file path to its database. This ensures pacman hooks will **automatically re-sign the UKI** during any future kernel updates!
5. **Verify Signatures:** Displays all successfully registered and signed files.

### 󰦃  3. Re-enable Secure Boot
Once all files are signed and keys are enrolled:
1. Reboot once more into your BIOS/UEFI.
2. Re-enable **Secure Boot**.
3. Boot back into your system and check the status: `sbctl status` (it should display Secure Boot as `active` and `setup_mode` as `false`).


