#!/bin/bash

sudo pacman -S --needed rclone --noconfirm


echo "Configuring Rclone for KDE Plasma"

mkdir -p ~/GoogleDrive ~/Scripts ~/.local/share/applications


# Script Configuration
SCRIPT_SYNC="$HOME/Scripts/sync_drive.sh"

cat << 'EOF' > "$SCRIPT_SYNC"
#!/bin/bash
rclone bisync ~/GoogleDrive gdrive: --create-empty-src-dirs --compare size,modtime
EOF

chmod +x "$SCRIPT_SYNC"


echo "Setting keyboard shotcut (Ctrl + Alt + R)"

ARQUIVO_DESKTOP="$HOME/.local/share/applications/rclone-sync.desktop"
cat << EOF > "$ARQUIVO_DESKTOP"
[Desktop Entry]
Type=Application
Exec=$SCRIPT_SYNC
Name=Sincronizar Google Drive
NoDisplay=true
EOF

if command -v kwriteconfig6 &> /dev/null; then
    kwriteconfig6 --file kglobalshortcutsrc --group "rclone-sync.desktop" --key "_launch" "Ctrl+Alt+R,none,Sincronizar Google Drive"
else
    kwriteconfig5 --file kglobalshortcutsrc --group "rclone-sync.desktop" --key "_launch" "Ctrl+Alt+R,none,Sincronizar Google Drive"
fi

systemctl --user restart plasma-kglobalaccel.service 2>/dev/null


rclone config create gdrive drive scope drive

rclone bisync ~/GoogleDrive gdrive: --create-empty-src-dirs --compare size,modtime --resync

