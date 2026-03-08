#!/bin/sh

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Esta operação requer privilégios administrativos. Execute com 'sudo'." >&2
    exit 1
fi

echo "--- Iniciando configuração do UFW ---"

# Restaura as configurações de fábrica para evitar conflitos
ufw --force reset

# Estabelece as políticas padrão de segurança
ufw default deny incoming
ufw default allow outgoing

# Ativa o firewall
ufw --force enable

echo "--- Sistema de proteção de rede ativado com sucesso. ---"
