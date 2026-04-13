# CachyOS Setup Guide

Commands for fish shell.

## Network & Hardware Optimization

### Realtek Wi-Fi Stabilization & IWD

Disable Wi-Fi power saving in NetworkManager and configure kernel module parameters to disable ASPM and deep sleep states for the Realtek adapter:

```bash
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[connection]\nwifi.powersave = 2" | sudo tee /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
echo "options rtw88_core disable_aspm=y disable_lps_deep=y ant_sel=2" | sudo tee /etc/modprobe.d/rtw88.conf
```

Install the high-performance network engine (IWD) and configure NetworkManager to use it as the backend:

```bash
sudo pacman -S iwd --noconfirm --needed
echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf
```

Disable MAC randomization and IPv6 to stabilize the connection:

```bash
echo -e "[device]\nwifi.scan-rand-mac-address=no" | sudo tee /etc/NetworkManager/conf.d/disable-random-mac.conf
echo -e "[connection]\nipv6.method=disabled" | sudo tee /etc/NetworkManager/conf.d/disable-ipv6.conf
```

Enable the IWD service:

```bash
sudo systemctl enable --now iwd
```

### Regulatory Domain Unlock (BR)

Unlock the maximum antenna transmission power and local 5GHz channels for Brazil:

```bash
sudo sed -i '/^WIRELESS_REGDOM=/d' /etc/conf.d/wireless-regdom
echo 'WIRELESS_REGDOM="BR"' | sudo tee -a /etc/conf.d/wireless-regdom > /dev/null
sudo iw reg set BR
```

### Optimize Arch Mirrors

Rate Arch Linux mirrors globally. We use a background ping to keep the Realtek adapter "warm" to prevent drops during the mirror check:

```bash
ping -i 0.2 1.1.1.1 > /dev/null 2>&1 &
set PING_PID $last_pid
sleep 1
sudo cachyos-rate-mirrors
kill $PING_PID
```

> Note: Every time you change your geographic location significantly (e.g., relocating from Brazil to Canada), you should re-run the cachyos-rate-mirrors step so the system updates to faster regional servers.

AMD Processor Memory Bypass (IOMMU)

Prevent AMD-Vi from blocking the Realtek adapter's memory access by injecting the IOMMU Passthrough rule into the Kernel command line.

Run the following block. It will check if the rule exists, and if not, inject it and rebuild the system image/bootloader:

```bash
sudo mkdir -p /etc/cmdline.d/
echo "iommu=pt" | sudo tee /etc/cmdline.d/iommu.conf > /dev/null
sudo mkinitcpio -P
sudo limine-update
```

## System Configuration

### Battery Charge Limit

First, retrieve your battery component information to find the correct battery identifier (e.g., BAT0, BAT1, BATT):

```bash
ls /sys/class/power_supply/
```
> replace `<battery_name>` for name founded, e.g. `BAT0`.

Verify the charge limit file exists for your specific battery:

```bash
ls /sys/class/power_supply/<battery_name>/charge_control_end_threshold
```

Create the `.service` file:
```bash
sudo nano /etc/systemd/system/battery-charge-threshold.service
```

Set the maximum battery charge threshold to 80%.

```toml
[Unit]
Description=Sets the maximum battery charge threshold to 80%
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 80 > /sys/class/power_supply/<battery_name>/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
```

Reload the daemon and enable the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now battery-charge-threshold.service
```

### SSD Trim Optimization

Enable weekly SSD trim to maintain performance and lifespan:

```bash
sudo systemctl enable --now fstrim.timer
```

## Storage and Symbolic Links

### Partition Mounting

Identify the drive's name and its partition UUID:

```bash
lsblk
```

> replace `<partition>` for name founded, e.g. `/dev/nvme0n1p2`.

```bash
sudo blkid <partition> # e.g., sudo blkid /dev/nvme0n1p2
```

Create the mount point and open the file system table:

```bash
sudo mkdir -p /data
sudo nano /etc/fstab
```

Append your partition to the end of the file. (Replace the UUID below with yours):

> replace `<your-partition-uuid>` for id founded, e.g. `UUID=522cf738-6361-4162-a895-abd155df2674`.

```bash
UUID=<your-partition-uuid>  /data  ext4  defaults  0  2
```

Reload the daemon and mount the drive:

```bash
sudo systemctl daemon-reload
sudo mount -a
```

### Directory Redirection

Transfer ownership and establish symbolic links for your user folders:

```bash
# Transfer ownership of the mounted drive to the current user
sudo chown -R $USER:$USER /data

# Create the directory structure on the secondary drive
mkdir -p /data/Documents
mkdir -p /data/Downloads
mkdir -p /data/Music
mkdir -p /data/Pictures
mkdir -p /data/Videos

# Remove the original empty directories from the user's home folder
rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos 2>/dev/null

# Establish the definitive symbolic links
ln -sfn /data/Documents ~/Documents
ln -sfn /data/Downloads ~/Downloads
ln -sfn /data/Music ~/Music
ln -sfn /data/Pictures ~/Pictures
ln -sfn /data/Videos ~/Videos
```

## Applications & Environment Setup

### Batch Installation

Install applications listed on install.txt and upgrade the system:

```bash
sudo pacman -Syu (awk 'NF' install.txt) --noconfirm --needed
```

Uninstall applications listed on uninstall.txt:

```bash
sudo pacman -Rns (awk 'NF' uninstall.txt) --noconfirm
```

### Default Apps

Paste this on `~/.config/mimeapps.list`:

```toml
[Default Applications]
x-scheme-handler/bitwarden=bitwarden.desktop
x-scheme-handler/http=brave-browser.desktop
x-scheme-handler/https=brave-browser.desktop
text/html=brave-browser.desktop
application/pdf=org.kde.okular.desktop
```

### Git Configuration

#### Global Git Credentials:

Set your global Git credentials:

```bash
git config --global user.name "pedroivo1"
git config --global user.email "pedroivoal1@gmail.com"
```

#### Configure SSH key

Create the SSH directory and configuration file:

```bash
mkdir -p ~/.ssh
nano ~/.ssh/config
```

Paste into the file:

```bash
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  AddKeysToAgent yes
```

Secure the SSH directory and config file with the correct permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
```

Generate SSH key:

```bash
ssh-keygen -t ed25519 -C "pedroivoal1@gmail.com"
```

#### Add the Key to GitHub

Copy your new public key directly to your clipboard:

```bash
wl-copy < ~/.ssh/id_ed25519.pub
```

Link it to your account:

1. Go to GitHub.com and log in.
2. Click your profile photo in the top right corner and select Settings.
3. In the left sidebar, click SSH and GPG keys.
4. Click the green New SSH key button.
5. Give it a title (e.g., "CachyOS Setup").
6. Leave the key type as "Authentication Key".
7. Paste your key into the "Key" field and click Add SSH key.

Test your connection to ensure everything is working:

```bash
ssh -T git@github.com
# Type: yes
```

> You should see a success message: "Hi pedroivo1! You've successfully authenticated...")

### Brave

1. Open
2. Click: `Set Brave as default browser`
3. Click: `Next`
4. Click: `Maybe later`
5. Unmark every thing
6. Click: `Finish`
7. Scroll down.
8. Click: `No thanks`

#### Bitwarden

Add bit warden extension.

1. Click: `Extensions`
2. Click: `More options`
3. Enable: `Pin to toolbar`

Configure Bitwarden

1. Click: `Bitwarden`
2. Click: `Login`
3. Type: <email>
4. Mark: Remember email
5. Click: `Continue`
6. Enter: <password>
7. Click: `Log in`

8. Settings->Autofill->Turn Off Chrome Autofill, Make Bitwarden your default password manager

## Desktop Environment (KDE Plasma)

### Panel Configuration

1. Right-click on the taskbar
2. Click: `Show Panel Configuration`

| Parameter | Value |
| :--- | :--- |
| Position | Bottom |
| Alignment | Center |
| Width | Fill width |
| Visibility | Dodge windows |
| Opacity | Adaptive |
| Floating | Panel and applets |
| Panel Height | 36 |
| Focus shortcut | None |

### Panel Widgets

1. Right-click on the taskbar
2. Click: `Add or Manage Widgets...`
3. Select: `Running`

Keep only following widgets:

- Application Launcher
- Digital Clock
- Icons-Only Task Manager
- System Tray

### Task Manager Apps

`Unping From Task Manager` all apps.

### System Tray

1. Right-click on System Tray
2. Click: `Configure System Tray...`

Set as `Never show (disabled)` on

Application Status:
- Arch-Update
- Get Plasma Browser Integration
- Kate Sessions

Hardware Control:
- Audio Volume
- Bluetooth
- Brightness and Color

### Okular Configuration

Set Okular as the default PDF application via the terminal:

```bash
xdg-mime default org.kde.okular.desktop application/pdf
```

Map the "Invert Colors" toggle:

1. Open Okular.
2. Navigate to: Settings -> Configure Keyboard Shortcuts...
3. Search for: Change Colors
4. Click the Shortcut column, select Custom, and input: Ctrl + R
5. Apply and exit.
