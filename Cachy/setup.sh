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


# ----------------------
# --- Symbolic Links ---
# ----------------------

# Claim ownership of the external drive
sudo chown -R $USER:$USER /mnt/data

# Define the core directories
FOLDERS=("Documents" "Downloads" "Music" "Pictures" "Videos")

for folder in "${FOLDERS[@]}"; do
    # 1. Create the permanent matrix on the data drive
    mkdir -p "/mnt/data/$folder"

    # 2. Safely handle existing default system folders
    if [ -d "$HOME/$folder" ] && [ ! -L "$HOME/$folder" ]; then
        # rmdir is a safety lock: it will only delete the folder if it is 100% empty.
        # If you have files there, it will leave them alone and print an error.
        rmdir "$HOME/$folder" 2>/dev/null
    fi

    # 3. Establish or update the portal safely
    # (-sfn forces the link and prevents nesting inside existing links)
    ln -sfn "/mnt/data/$folder" "$HOME/$folder"
done
