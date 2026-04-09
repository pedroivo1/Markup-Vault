# Fedora Setup Guide

## System Configuration

### System Update

Refresh repositories and upgrade the system base:
```bash
sudo dnf upgrade --refresh -y
```

### Battery Charge Limit

Retrieve your battery component information:
```bash
ls /sys/class/power_supply/
ls /sys/class/power_supply/BAT0/charge_control_end_threshold
```

Create the `.service` file:
```bash
sudo nano /etc/systemd/system/battery-limit.service
```

Paste the following configuration into the file:
```toml
[Unit]
Description=Sets the maximum battery charge limit to 80 percent
After=multi-user.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
ExecStart=/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
```

Reload the systemd service manager:
```bash
sudo systemctl daemon-reload
```

Enable the service to start automatically on boot:
```bash
sudo systemctl enable --now battery-limit.service
```

## Applications

### Batch Installation

Install applications from predefined list, apps.txt, skipping any unavailable packages:
```bash
sudo dnf install $(cat apps.txt) --skip-unavailable -y
```

### GitHub Configuration

#### Set global Git credentials.

```bash
git config --global user.name "pedroivo1"
git config --global user.email "pedroivoal1@gmail.com"
```

#### Create SSH key.

```bash
mkdir -p ~/.ssh
nano ~/.ssh/config
```

```txt
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  AddKeysToAgent yes
```

Secure the SSH directory and config file with the strict permissions required by SSH:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
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
```

> (Type yes if it asks to verify the fingerprint. You should see a success message: "Hi pedroivo1! You've successfully authenticated...")

```bash

```

```bash

```


### Flatpak & Bitwarden

Add the Flathub repository and install the Bitwarden desktop application:
```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.bitwarden.desktop -y
```

> Open the application and log in with your email and password.

### Brave Browser

Install the required core plugins, add the Brave repository, and install the browser:
```bash
sudo dnf install dnf-plugins-core

# Optional fallback: Manually import the GPG key if the repository addition requires it
# sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install brave-browser -y
```

Extensions:
- bitwarden [make it default password manager]


## Storage and Symbolic Links

### Partition Mounting

Identify drive's name:
```bash
lsblk
```

Identify partition UUID:
```bash
sudo blkid <partition> # /dev/nvme0n1p2
```

Create the mount point and open the file system table:
```bash
sudo mkdir -p /mnt/data
sudo nano /etc/fstab
```

Append the following line using the UUID of `sudo blkid <partition>` to the end of the file (this content is representative only):
> e.g.: UUID=522cf738-6361-4162-a895-abd155df2674  /mnt/data  ext4  defaults  0  2

```toml
#
# /etc/fstab
# Created by anaconda on Sun Apr  5 01:09:09 2026
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
UUID=374641fb-0100-4f11-9f2e-5725125a1031 / ext4 defaults 1 1
UUID=AB52-47FE /boot/efi vfat umask=0077,shortname=winnt 0 2
UUID=522cf738-6361-4162-a895-abd155df2674  /mnt/data  ext4  defaults  0  2
```

Reload the daemon and mount the drive immediately:
```bash
sudo systemctl daemon-reload
sudo mount -a
```

### Directory Redirection

Execute the following block to establish the definitive symbolic links:
```bash
# Transfer ownership of the mounted drive to the current user
sudo chown -R $USER:$USER /mnt/data

# Create the directory structure on the secondary drive
mkdir -p /mnt/data/Documents
mkdir -p /mnt/data/Downloads
mkdir -p /mnt/data/Music
mkdir -p /mnt/data/Pictures
mkdir -p /mnt/data/Videos

# Remove the original empty directories from the user's home folder
rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos 2>/dev/null

# Establish the definitive symbolic links
ln -sfn /mnt/data/Documents ~/Documents
ln -sfn /mnt/data/Downloads ~/Downloads
ln -sfn /mnt/data/Music ~/Music
ln -sfn /mnt/data/Pictures ~/Pictures
ln -sfn /mnt/data/Videos ~/Videos
```
