# CachyOS Network & Hardware Optimization (Advanced/Optional)

Commands for fish shell. Skip this file for a basic setup — see `setup.md`.

### Realtek Wi-Fi Stabilization & IWD

Disable Wi-Fi power saving in NetworkManager and configure kernel module parameters to disable ASPM and deep sleep states for the Realtek adapter:

```bash
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[connection]\nwifi.powersave = 2" | sudo tee /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
echo "options rtw88_core disable_aspm=y disable_lps_deep=y ant_sel=2" | sudo tee /etc/modprobe.d/rtw88.conf
```

Install the high-performance network engine (IWD) and configure NetworkManager to use it as the backend:

```bash
sudo pacman -S iwd --noconfirm --needed
echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf
```

Disable MAC randomization and IPv6 to stabilize the connection:

```bash
echo -e "[device]\nwifi.scan-rand-mac-address=no" | sudo tee /etc/NetworkManager/conf.d/disable-random-mac.conf
echo -e "[connection]\nipv6.method=disabled" | sudo tee /etc/NetworkManager/conf.d/disable-ipv6.conf
```

Enable the IWD service:

```bash
sudo systemctl enable --now iwd
```

### Regulatory Domain Unlock (BR)

Unlock the maximum antenna transmission power and local 5GHz channels for Brazil:

```bash
sudo sed -i '/^WIRELESS_REGDOM=/d' /etc/conf.d/wireless-regdom
echo 'WIRELESS_REGDOM="BR"' | sudo tee -a /etc/conf.d/wireless-regdom > /dev/null
sudo iw reg set BR
```

### Optimize Arch Mirrors

Rate Arch Linux mirrors globally. We use a background ping to keep the Realtek adapter "warm" to prevent drops during the mirror check:

```bash
ping -i 0.2 1.1.1.1 > /dev/null 2>&1 &
set PING_PID $last_pid
sleep 1
sudo cachyos-rate-mirrors
kill $PING_PID
```

> Note: Every time you change your geographic location significantly (e.g., relocating from Brazil to Canada), you should re-run the cachyos-rate-mirrors step so the system updates to faster regional servers.

AMD Processor Memory Bypass (IOMMU)

Prevent AMD-Vi from blocking the Realtek adapter's memory access by injecting the IOMMU Passthrough rule into the Kernel command line.

Run the following block. It will check if the rule exists, and if not, inject it and rebuild the system image/bootloader:

```bash
sudo mkdir -p /etc/cmdline.d/
echo "iommu=pt" | sudo tee /etc/cmdline.d/iommu.conf > /dev/null
sudo mkinitcpio -P
sudo limine-update
```
