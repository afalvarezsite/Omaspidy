# Arch Linux System Management Skills

Esta es tu hoja de habilidades de administración para gestionar este sistema Arch Linux optimizado. Carga y ejecuta estas directrices para realizar tareas de sistema con el máximo nivel de seguridad y rendimiento.

---

##   Habilidad 1: Gestión de Copias de Seguridad BTRFS & Restauración

Este sistema utiliza Snapper en una estructura de subvolúmenes BTRFS (`@`, `@home`, `@snapshots`, `@cache`, `@log`).

### 1. Crear Puntos de Restauración Seguros
* **Cuándo usar:** Antes de realizar actualizaciones masivas (`pacman -Syu`), compilar kernels o modificar archivos críticos de `/etc`.
* **Cómo operar:**
  * Llama al script `sys-backup` de forma no interactiva o ejecuta:
    ```bash
    sudo snapper -c root create --type single --description "Descripción del cambio"
    ```
  * Nunca uses el tipo `timeline` en operaciones manuales para evitar su auto-eliminación por el limpiador de Snapper.

### 2. Explorar y Purgar Snapshots
* **Cómo operar:**
  * Llama al menú interactivo `sys-snaps` de forma manual, o ejecuta `sudo snapper -c root ls` para listar.
  * Para ver los cambios introducidos entre un snapshot y el sistema actual, ejecuta:
    ```bash
    sudo snapper -c root status <ID_SNAPSHOT>..0
    ```
  * Para eliminar snapshots obsoletos y recuperar almacenamiento, usa `sudo snapper -c root delete <ID>`.

### 3. Operación de Rollback (Recuperación en caso de desastre)
* **Cómo operar:**
  * Si el sistema entra en un estado inestable, ejecuta la restauración completa:
    ```bash
    sudo snapper -c root rollback <ID_SNAPSHOT>
    ```
  * Seguidamente, solicita al usuario reiniciar el sistema con `sudo reboot` para arrancar en el subvolúmen restaurado.

---

## 󰏗  Habilidad 2: Aislamiento y Contenedores con Distrobox

Para mantener el sistema anfitrión (Arch) limpio y puro, el software de desarrollo de terceros, las bases de datos y las herramientas de pentesting se ejecutan de forma aislada en contenedores **Podman rootless** integrados en Wayland y PipeWire.

### 1. Administrar Contenedores
* **Cómo operar:**
  * Llama a `sys-distrobox` (`dbs`) para la gestión visual interactiva de ciclos de vida.
  * Para crear un entorno: `distrobox create --name <nombre> --image <imagen_oci>`.
  * Para ingresar a un entorno: `distrobox enter <nombre>`.

### 2. Exportación Segura de Aplicaciones
* **Cómo operar:**
  * Puedes hacer que las aplicaciones instaladas dentro de un contenedor se ejecuten transparentemente desde el host:
    * **Aplicaciones gráficas (aparecen en Anyrun):**
      ```bash
      distrobox enter <nombre_contenedor> -- distrobox-export --app <nombre_aplicacion>
      ```
    * **Binarios CLI (añade un enlace en ~/.local/bin):**
      ```bash
      distrobox enter <nombre_contenedor> -- distrobox-export --bin <comando>
      ```

---

## 󰒓  Habilidad 3: Optimización de Hardware e Intel Meteor Lake

tailored para el procesador **Intel Core Ultra 7 155H** + **Intel Arc Graphics**.

### 1. Gestión Térmica y de Procesador
* Habilita `thermald` para prevenir el throttling térmico de Intel:
  ```bash
  sudo systemctl enable --now thermald
  ```
* Asegúrate de que las flags `mitigations=off` e `intel_pstate=active` estén presentes en la línea de parámetros del kernel en systemd-boot (`/boot/loader/entries/*.conf`).

### 2. Habilitar Driver Gráfico Intel Xe de Alto Rendimiento
* Si el usuario experimenta problemas de FPS en Hyprland o desea habilitar el renderizado optimizado, comprueba el ID PCI con `lspci -nn | grep VGA` y fuerza el driver `xe` creando `/etc/modprobe.d/xe.conf`:
  ```ini
  options i915 force_probe=!7d05
  options xe force_probe=7d05
  ```
* Regenera la imagen de arranque:
  ```bash
  sudo mkinitcpio -P
  ```

---

## 󰃢  Habilidad 4: Rutinas de Mantenimiento e Higiene

### 1. Limpieza General de Paquetes
* Para limpiar la cache manteniendo únicamente las últimas 2 versiones de respaldo:
  ```bash
  sudo paccache -r -k 2
  ```
* Para purgar la cache de compilación de AUR de Paru:
  ```bash
  rm -rf "$HOME/.cache/paru/clone/"*
  ```

### 2. Borrado Interactivo de Huérfanos
* Llama al script `sys-clean` para desencadenar el buscador de FZF en terminal, permitiendo una desinstalación quirúrgica de librerías residuales sin comprometer paquetes deseados.
