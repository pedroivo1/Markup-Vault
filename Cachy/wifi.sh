#!/bin/bash

# Disable Wi-Fi power saving in NetworkManager
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[connection]\nwifi.powersave = 2" | sudo tee /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

# Disable ASPM and deep sleep states for the rtw88 core module
echo "options rtw88_core disable_aspm=y disable_lps_deep=y" | sudo tee /etc/modprobe.d/rtw88.conf

# 1. Installation of the high-performance network engine (IWD)
sudo pacman -S iwd --noconfirm needed

# 2. System configuration to abandon the legacy engine and adopt IWD
echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf

# 3. Disabling MAC randomization, which destabilizes Realtek hardware
echo -e "[device]\nwifi.scan-rand-mac-address=no" | sudo tee /etc/NetworkManager/conf.d/disable-random-mac.conf

# 4. Permanent activation of the new service and controller restart
sudo systemctl enable --now iwd

# 5. Suppression of the IPv6 protocol to stabilize Realtek hardware (Failure containment)
echo -e "[connection]\nipv6.method=disabled" | sudo tee /etc/NetworkManager/conf.d/disable-ipv6.conf

# 6. Forcing high-performance global DNS (Cloudflare) to resolve route bottlenecks
echo -e "[global-dns-domain-*]\nservers=1.1.1.1,1.0.0.1" | sudo tee /etc/NetworkManager/conf.d/dns-servers.conf
sudo systemctl restart NetworkManager

# 7. Rate Arch Linux mirrors around wolrd
# Warming Realtek so it doesn't break when cachyos-rate-mirrors is executed
ping -i 0.2 1.1.1.1 > /dev/null 2>&1 &
PING_PID=$!
sleep 1
sudo cachyos-rate-mirrors
kill $PING_PID
