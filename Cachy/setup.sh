#!/bin/sh

pacman -Syu --noconfirm

# Network Configuration (BR)
sed -i 's/#WIRELESS_REGDOM="BR"/WIRELESS_REGDOM="BR"/' /etc/conf.d/wireless-regdom
iw reg set BR
iw reg get

# Battery Configuration
cat <<EOF > /etc/systemd/system/battery-charge-threshold.service
[Unit]
Description=Estabelece o limite maximo de carga da bateria em 80%
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now battery-charge-threshold.service
