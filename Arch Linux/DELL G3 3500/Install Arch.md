# Instalação Arch Linux - Dell G3 3500

## 1. Wi-Fi Setup
Connecting to the internet via `iwctl`

```bash
iwctl
    device list
    station wlan0 scan
    station wlan0 get-networks
    station wlan0 connect <wifi-name> # e.g. MARIA_5G
    exit
```

## 2. Prepare Disk and Mounting

### Disk Partitioning
Preparing the NVMe disk

```bash
lsblk
cfdisk /dev/<disk> # e.g. nvme0n1
    # Create the partitions here
```

### Filesystem Formatting
Formatting the partitions (EFI, Root, Home)

```bash
mkfs.fat -F32 /dev/<partition> # e.g. nvme0n1p1 (EFI)
mkfs.ext4 /dev/<partition> # e.g. nvme0n1p2 (Root/Home)
mkfs.ext4 /dev/<partition> # e.g. nvme0n1p3 (Root/Home)
```

### Mount Filesystems
Mounting the partitions for installation

```bash
mount /dev/<partition> /mnt # root
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/<partition> /mnt/home # home
mount /dev/<partition> /mnt/boot/efi # boot
lsblk
```

## 3. Install Base System

### Mirrorlist Configuration
Updating and prioritizing Brazilian mirrors

```bash
pacman -Sy reflector
reflector --country Brazil --latest 10 --sort rate --verbose --save /etc/pacman.d/mirrorlist
```

Manually edit the list:
```bash
nano /etc/pacman.d/mirrorlist
```
> **Add (above other Servers):**
> `Server = https://mirror.osbeck.com/archlinux/$repo/os/$arch`

Update repositories:
```bash
pacman -Sy
```

### Base System Installation
Installing the base system, kernel, and firmware (including Intel microcode).

```bash
pacstrap /mnt base base-devel linux linux-headers linux-firmware nano intel-ucode
```

### Generate Fstab
Generating the fstab file.

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```

## 4. Configure System (Chroot)

### Chroot & Pacman Config
Accessing the installed system.

```bash
arch-chroot /mnt
```

Edit Pacman configurations:
```bash
nano /etc/pacman.conf
# Enable: Color, ParallelDownloads, [multilib]
```

### Timezone & Clock
Configuring São Paulo timezone.

```bash
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
```

### Locale & Keymap
Configuring locale and keymap.

```bash
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
```

### Network Identification
Defining hostname and hosts.

```bash
echo "DESKTOP-OAR8HS76" > /etc/hostname
nano /etc/hosts
```
> **Add:**
> ```text
> 127.0.0.1      localhost
> ::1            localhost
> 127.0.1.1      DESKTOP-OAR8HS76.localdomain DESKTOP-OAR8HS76
> ```

### Root Password & User
Setting passwords and creating user `pedro`.

```bash
passwd
# Set root password

EDITOR=nano visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL

useradd -mG wheel pedro
passwd pedro
# Set user password
```

### Additional Packages & Bootloader
Installing essential packages and GRUB.

```bash
pacman -S dosfstools mtools os-prober networkmanager iwd grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --recheck
```

### Bootloader Config
Configuring GRUB to detect other OS.

```bash
nano /etc/default/grub
# Uncomment: "GRUB_DISABLE_OS_PROBER=false"

grub-mkconfig -o /boot/grub/grub.cfg
```

### Network Configuration
Enabling NetworkManager with IWD backend.

```bash
systemctl enable NetworkManager

nano /etc/NetworkManager/NetworkManager.conf
```
> **Add:**
> ```ini
> [device]
> wifi.backend=iwd
> ```

### Finalize
Exiting and rebooting.

```bash
exit
umount -R /mnt
reboot
```
