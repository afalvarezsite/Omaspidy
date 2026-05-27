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
  - **Kernel Driver:** Built-in `i915` (mature) or `xe` (new high-performance driver, fully supported in `linux-cachyos`)
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

## 🛠️ Essential Utilities & System Management
- **File Manager (CLI):** Yazi
- **Fuzzy Finder:** fzf
- **System Backups:** Snapper + snap-pac + **systemd-boot-lifeboat** (Automated BTRFS snapshots with automatic boot entries in systemd-boot for easy system rollback/recovery)
- **Backlight Control:** **brightnessctl** (Lightweight, permission-safe CLI tool for screen and keyboard backlight)
- **Screen Temperature (Blue Light):** **hyprsunset** (Official Hyprland application to adjust screen temperature / blue light filter)
- **AUR Helper:** **paru** (Feature-rich, blazing fast Arch User Repository helper written in **Rust** for beautiful and safe package building)
- **Containerized Environments:** **distrobox** + **podman** (Highly optimized tool to run any Linux distribution inside a container seamlessly integrated with your host's Wayland, PipeWire, and GPU acceleration; keeps the host Arch system 100% clean and pristine)

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

