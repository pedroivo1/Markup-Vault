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

# Clears default empty directories before linking
rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos 2>/dev/null

ln -sfn /mnt/data/Documents ~/Documents
ln -sfn /mnt/data/Downloads ~/Downloads
ln -sfn /mnt/data/Music ~/Music
ln -sfn /mnt/data/Pictures ~/Pictures
ln -sfn /mnt/data/Videos ~/Videos


# -------------------------
# --- Git Configuration ---
# -------------------------
if ! command -v git &> /dev/null; then
    echo "Git package not found. Installing via apt..."
    sudo apt update && sudo apt install -y git
fi

git config --global user.email "pedroivoal1@gmail.com"
git config --global user.name "pedroivo1"

echo "Configuration complete."
