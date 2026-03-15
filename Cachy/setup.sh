#!/bin/sh

# Battery Configuration
cat <<EOF > /etc/systemd/system/battery-charge-threshold.service
[Unit]
Description=Sets the maximum battery charge threshold to 80%
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now battery-charge-threshold.service

# Git Configuration
git config --global user.email "pedroivoal1@gmail.com"
git config --global user.name "pedroivo1"
