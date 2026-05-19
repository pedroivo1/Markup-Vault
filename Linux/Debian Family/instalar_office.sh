#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

check_root_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}[!] Must run as root (sudo).${NC}"
        exit 1
    fi
}

update_repositories() {
    echo -e "${BLUE}[*] Updating package lists...${NC}"
    apt update -y
}

accept_ms_license() {
    echo -e "${BLUE}[*] Pre-accepting Microsoft Fonts EULA...${NC}"
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
}

install_packages() {
    echo -e "${BLUE}[*] Installing LibreOffice, language packs, and fonts...${NC}"
    apt install -y libreoffice \
                    libreoffice-plasma \
                    libreoffice-l10n-pt-br \
                    hunspell-pt-br \
                    hunspell-en-us \
                    ttf-mscorefonts-installer
}

cleanup_system() {
    echo -e "${BLUE}[*] Cleaning up unnecessary packages...${NC}"
    apt autoremove -y
    apt clean
    echo -e "${GREEN}[+] Success. Office suite completely installed.${NC}"
}

main() {
    check_root_privileges
    update_repositories
    accept_ms_license
    install_packages
    cleanup_system
}

main