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
kwriteconfig6 --file okularpartrc --group Shortcuts --key options_toggle_change_colors "Ctrl+R"
xdg-mime default org.kde.okular.desktop application/pdf

# Fish Configuration
mkdir -p ~/.config/fish/
cat <<EOF >> ~/.config/fish/config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
end
EOF
