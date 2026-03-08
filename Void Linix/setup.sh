#!/bin/sh

set -e

# CHECK SUDO
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This operation requires administrative privileges. Run with 'sudo'." >&2
    exit 1
fi

# GET USER NAME
printf "USER: "
read TARGET_USER
if [ -z "$TARGET_USER" ]; then
    echo "Error: The username cannot be blank." >&2
    exit 1
fi



# UPDATE SYSTEM
xbps-install -y void-repo-nonfree
xbps-install -Syu || xbps-install -Syu

# INSTALL DRIVERS
xbps-install -y linux-firmware-amd
xbps-install -y linux-firmware-network
xbps-install -y mesa-dri vulkan-radeon

# GRAPHICAL INTERFACE
xbps-install -y xorg
xbps-install -y xfce4 xfce4-plugins
xbps-install -y lightdm lightdm-gtk3-greeter
xbps-install -y gtk-engine-murrine gtk-engines-2
xbps-install -y arc-theme papirus-icon-theme

# SYSTEM SERVICES AND UTILITIES
xbps-install -y polkit
xbps-install -y NetworkManager network-manager-applet
xbps-install -y bluez
xbps-install -y pipewire wireplumber pipewire-pulse pavucontrol
xbps-install -y ufw
xbps-install -y gvfs thunar-volman
xbps-install -y flatpak

# SERVICES
rm -f /var/service/dhcpcd
ln -sf /etc/sv/dbus /var/service/
ln -sf /etc/sv/polkitd /var/service/
ln -sf /etc/sv/lightdm /var/service/
ln -sf /etc/sv/NetworkManager /var/service/
ln -sf /etc/sv/bluetoothd /var/service/
ln -sf /etc/sv/ufw /var/service/



# DEVELOPMENT TOOLS
xbps-install -y base-devel
xbps-install -y curl
xbps-install -y git
xbps-install -y alacritty
xbps-install -y zathura

# USER APPLICATIONS
xbps-install -y mousepad
xbps-install -y feh
xbps-install -y galculator
xbps-install -y evince

# OFFICE APPLICATIONS
xbps-install -y libreoffice libreoffice-i18n-pt-BR libreoffice-i18n-en-US

# FLATPAK APPLICATIONS
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.brave.Browser
flatpak install -y flathub com.visualstudio.code



# USER PERMISSIONS
usermod -aG audio,video,network,wheel,storage,bluetooth "$TARGET_USER"

echo "--- Configuration Complete! The system is ready for reboot. ---"
