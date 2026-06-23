#!/bin/bash

echo "Starting KDE Plasma configuration..."

# --------------------------------------------------------
# 1. Mouse & Touchpad -> Touchpad -> Natural Scrolling
# --------------------------------------------------------
echo "Configuring Touchpad..."
kwriteconfig6 --file kcminputrc --group "Libinput" --group "Touchpad" --key "NaturalScroll" "true"

# --------------------------------------------------------
# 2. Display & Monitor -> Screen Edges -> No Action
# --------------------------------------------------------
echo "Disabling Screen Edges..."
# Disables actions for all 8 standard screen zones/corners
for edge in Top TopLeft Left BottomLeft Bottom BottomRight Right TopRight; do
    kwriteconfig6 --file kwinrc --group "Effect-PresentWindows" --key "Border$edge" "0"
    kwriteconfig6 --file kwinrc --group "Effect-DesktopGrid" --key "Border$edge" "0"
done

# --------------------------------------------------------
# 3. Bluetooth -> Disable
# --------------------------------------------------------
echo "Disabling Bluetooth Service..."
# This disables bluetooth at the system level via systemd
sudo systemctl disable --now bluetooth 2>/dev/null || echo "Bluetooth service not found or already disabled."

# --------------------------------------------------------
# 4. Colors & Themes
# --------------------------------------------------------
echo "Setting Themes (Breeze Dark, No Splash, SDDM Breeze)..."
# Apply Breeze Dark Looks and Feel / Color Scheme
lookandfeeltool -a org.kde.breezedark.desktop 2>/dev/null || kwriteconfig6 --file kdeglobals --group "General" --key "ColorScheme" "BreezeDark"

# Splash Screen -> None
kwriteconfig6 --file ksplashrc --group "KSplash" --key "Theme" "None"
kwriteconfig6 --file ksplashrc --group "KSplash" --key "Engine" "none"

# Login Screen (SDDM) -> Breeze
if [ -f /etc/sddm.conf ]; then
    sudo sed -i 's/^Current=.*/Current=breeze/' /etc/sddm.conf
else
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=breeze" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null
fi

# --------------------------------------------------------
# 5. Default Applications
# --------------------------------------------------------
echo "Setting Default Applications..."
# Internet: Brave (Web), Brave (HTML renderer)
xdg-settings set default-web-browser brave-browser.desktop
mimeapps="~/.config/mimeapps.list"
mkdir -p ~/.config
{
  echo "[Default Applications]"
  echo "text/html=brave-browser.desktop"
  echo "x-scheme-handler/http=brave-browser.desktop"
  echo "x-scheme-handler/https=brave-browser.desktop"
  # Multimedia: Gwenview, Elisa, Haruna
  echo "image/png=org.kde.gwenview.desktop"
  echo "image/jpeg=org.kde.gwenview.desktop"
  echo "audio/mpeg=org.kde.elisa.desktop"
  echo "audio/x-vorbis+ogg=org.kde.elisa.desktop"
  echo "video/mp4=haruna.desktop"
  echo "video/quicktime=haruna.desktop"
  echo "video/x-matroska=haruna.desktop"
  # Documents: Kwrite, Okular
  echo "text/plain=org.kde.kwrite.desktop"
  echo "application/pdf=org.kde.okular.desktop"
} >> "$mimeapps"

# --------------------------------------------------------
# 6. Window Management (Effects & Scripts)
# --------------------------------------------------------
echo "Configuring Window Management..."
# Desktop Effects -> Off (Translucency, Wobbly Windows)
kwriteconfig6 --file kwinrc --group "Plugins" --key "translucencyEnabled" "false"
kwriteconfig6 --file kwinrc --group "Plugins" --key "wobblywindowsEnabled" "false"

# Kwin Scripts -> On (MinimizeAll)
kwriteconfig6 --file kwinrc --group "Plugins" --key "minimizeallEnabled" "true"

# --------------------------------------------------------
# 7. Recent Files -> Do not remember & Clear History
# --------------------------------------------------------
echo "Disabling and clearing Recent Files history..."
kwriteconfig6 --file kactivitymanagerd-pluginsrc --group "Plugin-org.kde.ActivityManager.Resources.Scoring" --key "enabled" "false"
# Clear the actual underlying database files for recent files/activities
rm -f ~/.local/share/kactivitymanagerd/resources/*

# --------------------------------------------------------
# 8. Software Update (Discover)
# --------------------------------------------------------
echo "Configuring Software Update frequencies..."
# Notification frequency -> Weekly (Interval is calculated in seconds: 604800 seconds = 1 week)
kwriteconfig6 --file kded_updatesrc --group "General" --key "CheckInterval" "604800"
# Apply system updates -> After rebooting (Offline updates)
kwriteconfig6 --file kded_updatesrc --group "General" --key "UseOfflineUpdates" "true"

# --------------------------------------------------------
# 9. Session -> Start with an empty session
# --------------------------------------------------------
echo "Setting Session to start empty..."
kwriteconfig6 --file ksmserverrc --group "General" --key "loginMode" "emptySession"

# --------------------------------------------------------
# 10. Keyboard Shortcuts (Meta + D for Minimize All Others)
# --------------------------------------------------------
echo "Assigning Shortcuts..."
# KDE Shortcuts are handled by kglobalshortcutsrc
kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "MinimizeAll" "Meta+D"

# --------------------------------------------------------
# 11. Screen Locking Wallpaper (Note on implementation)
# --------------------------------------------------------
# Note: "Configure Appearance... -> Add -> Select -> Apply" requires a specific image path.
# Below is the configuration key structure. Replace VALUE with your wallpaper path if desired.
# kwriteconfig6 --file kscreenlockerrc --group "Greeter" --group "Wallpaper" --group "org.kde.image" --group "General" --key "Image" "file:///path/to/your/wallpaper.jpg"

# --------------------------------------------------------
# Reload Settings to apply instantly
# --------------------------------------------------------
echo "Reloading Plasma configurations..."
qdbus6 org.kde.KWin /KWin reconfigure
qdbus6 org.kde.keyboard /Modules/khotkeys reread_configuration 2>/dev/null

echo "Done! Some changes (like SDDM, Bluetooth, and session changes) might require a logout/reboot to take full effect."
