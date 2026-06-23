#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

LIMIT="${1:-80}"
BATTERY=""
THRESHOLD_FILE=""
SV_DIR="/etc/sv/battery-charge-threshold"

check_root_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}[!] Deve ser executado como root (sudo).${NC}"
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
        echo -e "${RED}[!] Nenhuma bateria encontrada.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[+] Bateria: $BATTERY${NC}"
}

verify_hardware_support() {
    THRESHOLD_FILE="/sys/class/power_supply/${BATTERY}/charge_control_end_threshold"

    if [[ ! -f "$THRESHOLD_FILE" ]]; then
        echo -e "${RED}[!] Sem controle de carga para $BATTERY.${NC}"
        echo -e "${YELLOW}[i] Hardware/kernel não suportado.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[+] Limite: ${LIMIT}%${NC}"
}

create_runit_service() {
    echo -e "${BLUE}[*] Criando arquivos do serviço runit${NC}"
    mkdir -p "$SV_DIR"

    cat <<EOF > "$SV_DIR/run"
#!/bin/sh
# Aplica o limite
echo ${LIMIT} > /sys/class/power_supply/${BATTERY}/charge_control_end_threshold

# Como o runit reinicia serviços que terminam, 'exec pause' 
# congela o script sem consumir CPU para simular um comportamento "oneshot".
exec pause
EOF

    chmod +x "$SV_DIR/run"
}

enable_service() {
    echo -e "${BLUE}[*] Ativando serviço${NC}"
    
    # Verifica onde o sistema armazena os serviços ativos do runit
    # Diferentes distros e versões (antiX, Void, etc.) usam pastas variadas
    if [[ -d /service ]]; then
        ln -sf "$SV_DIR" /service/
    elif [[ -d /var/service ]]; then
        ln -sf "$SV_DIR" /var/service/
    elif [[ -d /etc/runit/runsvdir/default ]]; then
        ln -sf "$SV_DIR" /etc/runit/runsvdir/default/
    else
        echo -e "${RED}[!] Diretório de ativação do runit não encontrado.${NC}"
        exit 1
    fi

    echo -e "${BLUE}[*] Iniciando serviço${NC}"
    sleep 2 # Tempo para o supervisor detectar o novo symlink
    sv start battery-charge-threshold || true

    echo -e "${GREEN}[+] Sucesso. Limite travado em ${LIMIT}%.${NC}"
}

main() {
    check_root_privileges
    find_battery
    verify_hardware_support
    create_runit_service
    enable_service
}

main
