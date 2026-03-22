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

# 6. Rate Arch Linux mirrors around wolrd
# Warming Realtek so it doesn't break when cachyos-rate-mirrors is executed
ping -i 0.2 1.1.1.1 > /dev/null 2>&1 &
PING_PID=$!
sleep 1
sudo cachyos-rate-mirrors
kill $PING_PID

# ----------------------------------------
# --- 7. Regulatory Domain Unlock (BR) ---
# ----------------------------------------
# Unlocks maximum antenna transmission power and local 5GHz channels
sudo sed -i '/^WIRELESS_REGDOM=/d' /etc/conf.d/wireless-regdom
echo 'WIRELESS_REGDOM="BR"' | sudo tee -a /etc/conf.d/wireless-regdom > /dev/null
sudo iw reg set BR


# ----------------------------------------------
# --- 8. AMD Processor Memory Bypass (IOMMU) ---
# ----------------------------------------------
# Prevents AMD-Vi from blocking the Realtek adapter's memory access
if ! grep -q "iommu=pt" /etc/kernel/cmdline; then
    echo "Injecting IOMMU Passthrough rule into Kernel command line..."
    # Appends the rule safely to the end of the configuration line
    sudo sed -i 's/$/ iommu=pt/' /etc/kernel/cmdline

    # Rebuilds the system image and updates the bootloader to read the new rule
    sudo mkinitcpio -P
    sudo limine-update
else
    echo "IOMMU Passthrough is already configured."
fi
