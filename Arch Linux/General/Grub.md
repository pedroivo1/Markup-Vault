# GRUB Configuration

## Necessary for Beatyfull Dual-Boot

### Install OS Detector and Edit Config

```bash
sudo pacman -S --noconfirm os-prober
sudo nano /etc/default/grub
    # Edit: "GRUB_DISABLE_OS_PROBER=false"
```

### Install GRUB to EFI Partition
Installs the bootloader to the EFI directory (Set Arch GRUB as system boot).

```bash
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --recheck
```

### Install Themes
Install from sites like [GNOME-LOOK](https://www.gnome-look.org/browse?cat=109&ord=rating)
```bash
tar -xf <compacted-theme>
sudo mkdir -p /boot/grub/themes
sudo mv -r <theme> /boot/grub/themes/
```

### Configure Theme and Resolution
Edit the main configuration file again to apply visual changes.

```bash
sudo nano /etc/default/grub
    # Edit: GRUB_THEME="/boot/grub/themes/<theme>/theme.txt"
    # Edit: GRUB_GFXMODE=1920x1080 # (Your monitor's resolution)
```

### Generate Final Configuration
Apply all changes by generating a new `grub.cfg`.

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Optional

### Install GUI Tools
If you prefer a graphical interface to manage boot entries.

```bash
sudo pacman -S --noconfirm grub-customizer xhost
xhost +si:localuser:root
sudo grub-customizer
```
