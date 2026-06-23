#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

update_repositories() {
    echo -e "${BLUE}[*] Updating package lists...${NC}"
    # O sudo vai pedir a sua senha aqui na primeira execução
    sudo dnf makecache
}

install_ms_fonts() {
    echo -e "${BLUE}[*] Fetching and installing Microsoft Fonts...${NC}"
    sudo dnf install -y curl cabextract fontconfig
    sudo dnf install -y https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
}

install_packages() {
    echo -e "${BLUE}[*] Installing LibreOffice, language packs, and dictionaries...${NC}"
    sudo dnf install -y libreoffice \
                   libreoffice-langpack-pt-BR \
                   hunspell-pt-BR \
                   hunspell-en-US
}

cleanup_system() {
    echo -e "${BLUE}[*] Cleaning up unnecessary packages...${NC}"
    sudo dnf autoremove -y
    sudo dnf clean packages
    echo -e "${GREEN}[+] Success. Office suite completely installed.${NC}"
}

main() {
    update_repositories
    install_ms_fonts
    install_packages
    cleanup_system
}

main
