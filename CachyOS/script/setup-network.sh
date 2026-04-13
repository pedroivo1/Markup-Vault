#!/bin/bash

set -e

# Disable wifi power saving and configure Realtek kernel module
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[connection]\nwifi.powersave = 2" | sudo tee /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf > /dev/null
echo "options rtw88_core disable_aspm=y disable_lps_deep=y ant_sel=2" | sudo tee /etc/modprobe.d/rtw88.conf > /dev/null

# Install and configure IWD as NetworkManager backend
sudo pacman -S iwd --noconfirm --needed
echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf > /dev/null

# Disable MAC randomization and IPv6
echo -e "[device]\nwifi.scan-rand-mac-address=no" | sudo tee /etc/NetworkManager/conf.d/disable-random-mac.conf > /dev/null
echo -e "[connection]\nipv6.method=disabled" | sudo tee /etc/NetworkManager/conf.d/disable-ipv6.conf > /dev/null
sudo systemctl enable --now iwd

# Unlocking regulatory domain (BR)
sudo sed -i '/^WIRELESS_REGDOM=/d' /etc/conf.d/wireless-regdom
echo 'WIRELESS_REGDOM="BR"' | sudo tee -a /etc/conf.d/wireless-regdom > /dev/null
sudo iw reg set BR

# Optimize Arch mirrors (with background ping to keep adapter warm)"
# Start the ping in the background
ping -i 0.2 1.1.1.1 > /dev/null 2>&1 &
PING_PID=$!
sleep 1
# Run the mirror rater
sudo cachyos-rate-mirrors
# Kill the background ping once finished
kill $PING_PID

# Configure AMD IOMMU Passthrough and update bootloader"
sudo mkdir -p /etc/cmdline.d/
echo "iommu=pt" | sudo tee /etc/cmdline.d/iommu.conf > /dev/null
sudo mkinitcpio -P
sudo limine-update

# Turn off Global PCIe ASPM"
echo "pcie_aspm=off" | sudo tee /etc/cmdline.d/aspm.conf > /dev/null
sudo mkinitcpio -P
sudo limine-update

sudo rm /etc/cmdline.d/aspm.conf
sudo mkinitcpio -P
sudo limine-update

echo "=================================================="
echo "  Setup Complete! Please reboot to apply changes. "
echo "=================================================="
