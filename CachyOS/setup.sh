#!/bin/bash

# -----------------------------
# --- Battery Configuration ---
# -----------------------------
cat <<EOF | sudo tee /etc/systemd/system/battery-charge-threshold.service > /dev/null
[Unit]
Description=Sets the maximum battery charge threshold to 80%
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now battery-charge-threshold.service


# -----------------------------
# --- SSD Trim Optimization ---
# -----------------------------
# Enables weekly SSD trim to maintain performance and lifespan
sudo systemctl enable --now fstrim.timer


# ----------------------
# --- Symbolic Links ---
# ----------------------
sudo chown -R $USER:$USER /mnt/data

mkdir -p /mnt/data/Documents
mkdir -p /mnt/data/Downloads
mkdir -p /mnt/data/Music
mkdir -p /mnt/data/Pictures
mkdir -p /mnt/data/Videos

rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos 2>/dev/null

ln -sfn /mnt/data/Documents ~/Documents
ln -sfn /mnt/data/Downloads ~/Downloads
ln -sfn /mnt/data/Music ~/Music
ln -sfn /mnt/data/Pictures ~/Pictures
ln -sfn /mnt/data/Videos ~/Videos


# ---------------------
# --- Download Apps ---
# ---------------------
sudo pacman -Syu $(cat apps.txt) --noconfirm --needed


# ---------------------
# --- User Configs ----
# ---------------------

# Okular Configuration
xdg-mime default org.kde.okular.desktop application/pdf

# Fish Configuration
mkdir -p ~/.config/fish/
cat <<EOF >> ~/.config/fish/config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
end
EOF


# -------------------------
# --- Git Configuration ---
# -------------------------
git config --global user.email "pedroivoal1@gmail.com"
git config --global user.name "pedroivo1"
