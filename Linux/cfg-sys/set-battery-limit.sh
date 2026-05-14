#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status,
# treat unset variables as an error, and catch pipeline failures.
set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# --- Global Variables ---
LIMIT="${1:-80}"
BATTERY=""
THRESHOLD_FILE=""
SERVICE_FILE="/etc/systemd/system/battery-charge-threshold.service"

# --- Functions ---

check_root_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}[!] Must run as root (sudo).${NC}"
        exit 1
    fi
}

find_battery() {
    for bat in /sys/class/power_supply/BAT*; do
        if [[ -d "$bat" ]]; then
            BATTERY=$(basename "$bat")
            break
        fi
    done

    if [[ -z "$BATTERY" ]]; then
        echo -e "${RED}[!] No battery found.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[+] Battery: $BATTERY${NC}"
}

verify_hardware_support() {
    THRESHOLD_FILE="/sys/class/power_supply/${BATTERY}/charge_control_end_threshold"

    if [[ ! -f "$THRESHOLD_FILE" ]]; then
        echo -e "${RED}[!] No charge control for $BATTERY.${NC}"
        echo -e "${YELLOW}[i] Hardware/kernel unsupported.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[+] Limit: ${LIMIT}%${NC}"
}

create_systemd_service() {
    echo -e "${BLUE}[*] Creating service file${NC}"

    cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Set battery charge threshold to ${LIMIT}%
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo ${LIMIT} > /sys/class/power_supply/${BATTERY}/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
EOF
}

enable_service() {
    echo -e "${BLUE}[*] Reloading daemon${NC}"
    systemctl daemon-reload

    echo -e "${BLUE}[*] Starting service${NC}"
    systemctl enable --now battery-charge-threshold.service

    echo -e "${GREEN}[+] Success. Locked at ${LIMIT}%.${NC}"
}

main() {
    check_root_privileges
    find_battery
    verify_hardware_support
    create_systemd_service
    enable_service
}

# --- Execution ---
main
