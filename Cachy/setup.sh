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


# -------------------------
# --- Git Configuration ---
# -------------------------
git config --global user.email "pedroivoal1@gmail.com"
git config --global user.name "pedroivo1"


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


# ----------------------
# --- Symbolic Links ---
# ----------------------

# 1. Reivindicação de Posse
sudo chown -R $USER:$USER /mnt/data

# 2. Construção da Matriz na partição isolada
mkdir -p /mnt/data/Documents
mkdir -p /mnt/data/Downloads
mkdir -p /mnt/data/Music
mkdir -p /mnt/data/Pictures
mkdir -p /mnt/data/Videos

# 3. Limpa-Trilhos: Remove as pastas padrões do sistema apenas se estiverem vazias
rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos 2>/dev/null

# 4. Ancoragem Perfeita e Blindada
ln -sfn /mnt/data/Documents ~/Documents
ln -sfn /mnt/data/Downloads ~/Downloads
ln -sfn /mnt/data/Music ~/Music
ln -sfn /mnt/data/Pictures ~/Pictures
ln -sfn /mnt/data/Videos ~/Videos
