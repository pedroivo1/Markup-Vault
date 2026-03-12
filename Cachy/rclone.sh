#!/bin/sh

pacman -Syu --noconfirm
pacman -S rclone --noconfirm

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
mkdir -p "$USER_HOME/GoogleDrive"
mkdir -p "$USER_HOME/.config/systemd/user/"

cat <<EOF > "$USER_HOME/.config/systemd/user/rclone-gdrive.service"
[Unit]
Description=Montagem Automática do Google Drive (Rclone)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount gdrive: %h/GoogleDrive --vfs-cache-mode full
ExecStop=/usr/bin/fusermount -u %h/GoogleDrive
Restart=on-failure

[Install]
WantedBy=default.target
EOF

chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/GoogleDrive"
chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/.config/systemd/user/"

sudo -u "$SUDO_USER" rclone config create gdrive drive scope 1

sudo -u "$SUDO_USER" XDG_RUNTIME_DIR=/run/user/$(id -u "$SUDO_USER") systemctl --user daemon-reload
sudo -u "$SUDO_USER" XDG_RUNTIME_DIR=/run/user/$(id -u "$SUDO_USER") systemctl --user enable --now rclone-gdrive.service
