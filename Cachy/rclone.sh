#!/bin/sh

pacman -Syu rclone --noconfirm --needed

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
USER_ID=$(id -u "$SUDO_USER")
mkdir -p "$USER_HOME/GoogleDrive"
mkdir -p "$USER_HOME/.config/systemd/user/"

# Create the service file
cat <<EOF > "$USER_HOME/.config/systemd/user/rclone-gdrive.service"
[Unit]
Description=Google Drive Automatic Mount (Rclone)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount gdrive: %h/GoogleDrive --vfs-cache-mode full --vfs-cache-max-age 87600h
ExecStop=/usr/bin/fusermount3 -u %h/GoogleDrive
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# Correct permissions
chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/GoogleDrive"
chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/.config/systemd/user/"

# Create the rclone config
sudo -u "$SUDO_USER" rclone config create gdrive drive scope drive

# Reload and enable the service for the user immediately
sudo -u "$SUDO_USER" XDG_RUNTIME_DIR=/run/user/$USER_ID systemctl --user daemon-reload
sudo -u "$SUDO_USER" XDG_RUNTIME_DIR=/run/user/$USER_ID systemctl --user enable --now rclone-gdrive.service



# ----------------
# --- rclone 2 ---
# ----------------
# #!/bin/bash
#
# sudo pacman -S --needed rclone --noconfirm
#
#
# echo "Configuring Rclone for KDE Plasma"
#
# mkdir -p ~/GoogleDrive ~/Scripts ~/.local/share/applications
#
#
# # Script Configuration
# SCRIPT_SYNC="$HOME/Scripts/sync_drive.sh"
#
# cat << 'EOF' > "$SCRIPT_SYNC"
# #!/bin/bash
# rclone bisync ~/GoogleDrive gdrive: --create-empty-src-dirs --compare size,modtime
# EOF
#
# chmod +x "$SCRIPT_SYNC"
#
#
# echo "Setting keyboard shotcut (Ctrl + Alt + R)"
#
# ARQUIVO_DESKTOP="$HOME/.local/share/applications/rclone-sync.desktop"
# cat << EOF > "$ARQUIVO_DESKTOP"
# [Desktop Entry]
# Type=Application
# Exec=$SCRIPT_SYNC
# Name=Sincronizar Google Drive
# NoDisplay=true
# EOF
#
# if command -v kwriteconfig6 &> /dev/null; then
#     kwriteconfig6 --file kglobalshortcutsrc --group "rclone-sync.desktop" --key "_launch" "Ctrl+Alt+R,none,Sincronizar Google Drive"
# else
#     kwriteconfig5 --file kglobalshortcutsrc --group "rclone-sync.desktop" --key "_launch" "Ctrl+Alt+R,none,Sincronizar Google Drive"
# fi
#
# systemctl --user restart plasma-kglobalaccel.service 2>/dev/null
#
#
# rclone config create gdrive drive scope drive
#
# rclone bisync ~/GoogleDrive gdrive: --create-empty-src-dirs --compare size,modtime --resync
