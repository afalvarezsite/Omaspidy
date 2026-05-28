# 🕸️ Spider-Man Arch Linux Bootstrap & Dotfiles

[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue.svg?logo=arch-linux&logoColor=white&color=1793D1)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/WM-Hyprland-neon.svg?logo=hyprland&logoColor=white&color=E60026)](https://hyprland.org/)
[![Shell-Zsh](https://img.shields.io/badge/Shell-Zsh-black.svg?logo=gnubash&logoColor=white&color=ff3b5c)](https://www.zsh.org/)
[![Style](https://img.shields.io/badge/Theme-Spider--Man-red.svg?style=flat-square&color=ff1e43)](https://github.com/adrianoml/ArchInstallGuide)

Una guía e instalador automatizado para desplegar un entorno premium **Hyprland + CLI moderna de Rust + Tema Rojinegro (Spider-Man)** ultraoptimizado para plataformas de alto rendimiento (Intel Meteor Lake, almacenamiento SSD NVMe y sistema de archivos BTRFS con subvolúmenes redundantes).

---

## 🚀 Método de Instalación en Dos Fases

La instalación se realiza siguiendo una lógica sumamente limpia para mantener el sistema base puro y ligero:
1. **Fase 1 (Manual/Live USB):** Bootear con el USB de Arch Linux, realizar la instalación mínima del sistema base con BTRFS y configurar el cargador de arranque con optimizaciones extremas.
2. **Fase 2 (Automática/Curl):** Iniciar en el nuevo sistema y ejecutar mediante un comando `curl` el script de post-instalación que desplegará de forma automatizada todo el entorno visual, utilidades, servicios y dotfiles.

---

## 🛠️ Fase 1: Instalación Mínima (Desde el Live USB)

Tienes dos métodos disponibles para realizar la instalación mínima del sistema base:
- **[Método A: Instalación Manual](#método-a-instalación-manual-btrfs-optimizado)** (Recomendado para máximo control y optimizaciones específicas).
- **[Método B: Instalación Guiada (archinstall)](#método-b-instalación-guiada-con-archinstall)** (Más rápido y sencillo usando el asistente oficial).

---

## Método A: Instalación Manual (BTRFS Optimizado)

Sigue estos pasos detallados tras arrancar con el medio de instalación oficial de Arch Linux si prefieres realizar todo el particionado y montajes a mano.

### 1. Preparación e Internet
Carga la distribución de teclado en español y verifica que posees conectividad a internet:
```bash
loadkeys es
ping -c 3 google.com
```
*(Si usas Wi-Fi, conéctate usando `iwctl` antes de proseguir)*.

Actualiza el reloj del sistema:
```bash
timedatectl set-ntp true
```

### 2. Particionado del Disco (GPT + BTRFS)
Identifica tu unidad de almacenamiento (normalmente `/dev/nvme0n1` o `/dev/sda`):
```bash
lsblk
```
Usa `gdisk` para particionar el disco con una estructura GPT optimizada:
```bash
gdisk /dev/nvme0n1
```
Crea una estructura de dos particiones:
1. **Partición EFI:** `n` ➡️ número `1` ➡️ primer sector `default` ➡️ tamaño `+1G` ➡️ código de tipo `EF00` (EFI System).
2. **Partición de Sistema (BTRFS):** `n` ➡️ número `2` ➡️ primer sector `default` ➡️ último sector `default` ➡️ código de tipo `8300` (Linux filesystem).
3. Escribe los cambios pulsando `w` y confirma.

### 3. Formateo y Estructura de Subvolúmenes BTRFS
Formatea las particiones creadas:
```bash
mkfs.vfat -F 32 -n BOOT /dev/nvme0n1p1
mkfs.btrfs -f -L ARCH /dev/nvme0n1p2
```

Monta temporalmente la partición de sistema para estructurar los subvolúmenes BTRFS recomendados para snapper:
```bash
mount /dev/nvme0n1p2 /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
btrfs subvolume create @snapshots
btrfs subvolume create @cache
btrfs subvolume create @log
cd /
umount /mnt
```

### 4. Montaje Optimizado de Particiones y Subvolúmenes
Monta los subvolúmenes utilizando flags de montaje de alto rendimiento optimizadas para SSD NVMe y compresión en tiempo real:
```bash
# Flags recomendadas
FLAGS="noatime,ssd,compress=zstd:1,discard=async"

# Montar raíz
mount -o $FLAGS,subvol=@ /dev/nvme0n1p2 /mnt

# Crear directorios para los demás puntos de montaje
mkdir -p /mnt/{boot,home,.snapshots,var/cache,var/log}

# Montar subvolúmenes secundarios
mount -o $FLAGS,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o $FLAGS,subvol=@snapshots /dev/nvme0n1p2 /mnt/.snapshots
mount -o $FLAGS,subvol=@cache /dev/nvme0n1p2 /mnt/var/cache
mount -o $FLAGS,subvol=@log /dev/nvme0n1p2 /mnt/var/log

# Montar partición EFI
mount /dev/nvme0n1p1 /mnt/boot
```

### 5. Instalación del Sistema Base Indispensable
Instala únicamente los paquetes esenciales del sistema raíz utilizando `pacstrap`:
```bash
pacstrap -K /mnt base linux linux-firmware btrfs-progs networkmanager sudo nano vi git curl
```

### 6. Configuración Inicial del Sistema (`arch-chroot`)
Genera la tabla de montajes del sistema e ingresa mediante chroot:
```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

#### Localización y Zona Horaria
```bash
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

# Editar locales de sistema
echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Configuración de teclado y variables de lenguaje
echo "LANG=es_ES.UTF-8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf
```

#### Nombre de Host y Red
```bash
echo "arch-spidey" > /etc/hostname
systemctl enable NetworkManager
```

#### Creación del Usuario y privilegios Sudo
Reemplaza `adri` con tu nombre de usuario preferido:
```bash
# Contraseña para root
passwd

# Crear usuario normal con grupos de sistema y cambiar shell
useradd -m -G wheel,video,audio,storage -s /bin/bash adri
passwd adri

# Habilitar privilegios sudo para el grupo wheel
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/wheel
```

### 7. Configuración de Cargador de Arranque Moderno (`systemd-boot`)
Instala el cargador de arranque nativo de systemd en la partición EFI:
```bash
bootctl install
```

Crea la configuración general del cargador en `/boot/loader/loader.conf`:
```ini
timeout 3
default arch.conf
editor no
```

Crea la entrada del cargador de arranque en `/boot/loader/entries/arch.conf` e incluye los parámetros de kernel ultraoptimizados (**`mitigations=off`** para máximo rendimiento del procesador y **`intel_pstate=active`**):
```ini
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img (opcional si instalas intel-ucode ahora, el script lo manejará por ti)
initrd  /initramfs-linux.img
options root=UUID=AQUÍ_EL_UUID_DE_LA_PARTICION_BTRFS rw rootflags=subvol=@ mitigations=off intel_pstate=active
```
*(Puedes obtener el UUID de tu partición BTRFS ejecutando `:r !blkid -s UUID -o value /dev/nvme0n1p2` desde dentro de nano/vi, o saliendo momentáneamente)*.

### 8. Finalización y Reinicio
Sal del chroot, desmonta todas las particiones de forma segura y reinicia:
```bash
exit
umount -R /mnt
reboot
```

---

## Método B: Instalación Guiada con `archinstall`

Si prefieres evitar el particionado manual y el proceso en chroot, puedes utilizar el asistente interactivo oficial de Arch Linux. Sigue estos pasos para lograr una instalación mínima perfectamente compatible con este ecosistema.

### 1. Inicio y Conexión
Al arrancar el USB de Arch Linux, configura el idioma y la red (si no se conecta por cable):
```bash
loadkeys es
# Si usas Wi-Fi
iwctl
```

Lanza el asistente interactivo:
```bash
archinstall
```

### 2. Configuración en el Menú de `archinstall`
Modifica las siguientes opciones en el menú interactivo para que coincidan con los requerimientos óptimos de nuestro entorno:

1. **Archinstall language**: Selecciona tu idioma (ej. `Spanish`).
2. **Keyboard layout**: Selecciona `es` (español).
3. **Locale**: Configura la codificación regional (ej. `es_ES.UTF-8` para idioma y `Europe/Madrid` para zona horaria).
4. **Mirrors**: Elige la opción para seleccionar espejos rápidos de tu país/región.
5. **Disk configuration**:
   - Selecciona tu disco principal (ej. `/dev/nvme0n1`).
   - Elige **Use a best-effort default partition layout** ➡️ **Btrfs** (Recomendado para snapper y backups automáticos).
   - *Nota:* Esto creará automáticamente la partición EFI FAT32 y la raíz BTRFS con los subvolúmenes `@` y `@home`.
6. **Bootloader**: Selecciona **systemd-boot** (Cargador de arranque moderno e integrado).
7. **Kernel**: Selecciona **linux** (El kernel oficial básico).
8. **Profile**:
   - Entra en *Profile* ➡️ *Type* y selecciona **Minimal** (Crucial: **NO** instales ningún entorno de escritorio desde aquí, nuestro script lo instalará todo de forma óptima).
9. **Audio**: Selecciona **Pipewire** (Moderno y de alta fidelidad).
10. **Network configuration**: Selecciona **NetworkManager** (Obligatorio para que funcione la detección de red en nuestro script).
11. **Additional packages**: Escribe exactamente `git curl intel-ucode` (o `amd-ucode` si usas AMD) separados por espacio para tenerlos ya instalados en tu nuevo sistema.
12. **User accounts**:
    - Añade un nuevo usuario (ej. `adri`), asígnale una contraseña segura y marca la casilla **Yes** en *Promote user to administrator (sudo)*.
    - Opcionalmente, define una contraseña para el usuario `root`.

### 3. Instalar y Reiniciar
- Ve a **Install** en la parte inferior y presiona Enter.
- Revisa el resumen de configuración generado y pulsa Enter para iniciar el proceso de instalación.
- Al finalizar, el asistente te preguntará si deseas hacer *chroot* en el nuevo sistema para realizar cambios manuales. Selecciona **Yes** si deseas habilitar de antemano el parámetro de kernel `mitigations=off` (altamente recomendado).

#### Opcional: Configurar `mitigations=off` antes de reiniciar
Si entraste al chroot (o quieres hacerlo de forma rápida):
```bash
# Editar la configuración del cargador de arranque
nano /boot/loader/entries/*.conf
```
En la línea que comienza por `options`, añade al final:
```ini
mitigations=off intel_pstate=active
```
Guarda el archivo (`Ctrl + O`, `Enter`, `Ctrl + X`) y sal del chroot escribiendo `exit`.

Finalmente, reinicia el ordenador:
```bash
reboot
```

---

## ⚡ Fase 2: Automatización y Despliegue (Desde tu Nuevo Sistema)

Una vez que el ordenador reinicie, introduce tus credenciales de usuario normal (`adri`) creadas anteriormente.

Asegúrate de estar conectado a internet. Si usas conexión por cable se detectará automáticamente, si necesitas Wi-Fi puedes configurarlo rápidamente usando la interfaz de terminal de NetworkManager:
```bash
nmtui
```

Ahora, ejecuta el siguiente comando en la terminal para descargar e iniciar el script instalador:

```bash
curl -sSL https://raw.githubusercontent.com/yourusername/ArchInstallGuide/main/dotfiles/install.sh | bash
```

> [!NOTE]
> **¿Quieres usar tu propio repositorio Fork?**
> Si has realizado cambios en tu propio repositorio o deseas apuntar a otra URL, puedes pasar la variable de entorno `REPO_URL` directamente en el comando:
> ```bash
> REPO_URL="https://github.com/tu-usuario/ArchInstallGuide.git" curl -sSL https://raw.githubusercontent.com/tu-usuario/ArchInstallGuide/main/dotfiles/install.sh | bash
> ```

El script detectará de forma inteligente la ejecución remota, configurará los **repositorios optimizados de CachyOS** para descargar binarios compilados específicamente para el conjunto de instrucciones de tu procesador (`x86-64-v3` / AVX2), actualizará todo el sistema a este estándar optimizado e instalará el **kernel de alto rendimiento `linux-cachyos`** (generando automáticamente su entrada en `systemd-boot` con las flags `mitigations=off intel_pstate=active` activadas por defecto). Finalmente, clonará tu repositorio de dotfiles completo en `$HOME/.dotfiles` y ejecutará la instalación de todo el entorno gráfico (Hyprland, drivers Intel, herramientas modernas y dotfiles enlazados mediante Stow).

---

## 🌟 Componentes y Ajustes Posteriores

Una vez completada la ejecución del script, el sistema se reiniciará automáticamente y serás recibido por la pantalla de login gráfico de **`greetd` (tuigreet)** completamente tematizada. 

Al entrar a Hyprland:
- Abre la consola con `Super + Enter`.
- Presiona `Super + K` para desplegar el catálogo de atajos interactivo en FZF.
- Presiona `Super + S` para lanzar la utilidad de intercambio de archivos nativa LocalSend (`sys-share`).
- Ejecuta `sys-clean` en cualquier momento para mantener el sistema libre de huérfanos y paquetes temporales residuales.
