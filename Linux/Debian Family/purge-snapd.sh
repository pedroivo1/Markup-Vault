#!/bin/bash

# Garante que o script está rodando como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, rode este script como root (use sudo)."
  exit 1
fi

echo "=== Iniciando a remoção completa do Snap do Kubuntu ==="

# 1. Remove todos os pacotes snap instalados individualmente (necessário antes de remover o snapd)
echo "Desinstalando aplicativos snap..."
while [ "$(snap list 2>/dev/null | wc -l)" -gt 0 ]; do
    for snapname in $(snap list 2>/dev/null | awk '{print $1}' | grep -v -E "Name|refreshed"); do
        snap remove --purge "$snapname" 2>/dev/null
    done
done

# 2. Para e desativa os serviços do snapd
echo "Parando os serviços do snapd..."
systemctl stop snapd.service snapd.socket snapd.seeded.service 2>/dev/null
systemctl disable snapd.service snapd.socket snapd.seeded.service 2>/dev/null

# 3. Remove o snapd e suas dependências via APT
echo "Removendo o pacote snapd do sistema..."
apt purge -y snapd

# 4. Remove diretórios e resquícios do Snap no sistema
echo "Limpando diretórios residuais..."
rm -rf /var/cache/snapd/
rm -rf /~/snap
rm -rf /root/snap
rm -rf /var/snap
rm -rf /var/lib/snapd
rm -rf /var/lib/snapd/

# 5. Cria a trava (pinning) no APT para bloquear a reinstalação automática do snapd
echo "Criando regra de bloqueio para o APT..."
cat <<EOF> /etc/apt/preferences.d/nosnap.pref
# Bloqueia a instalação do snapd e pacotes relacionados
Package: snapd
Pin: release a=*
Pin-Priority: -10

Package: ubuntu-core-launcher
Pin: release a=*
Pin-Priority: -10
EOF

# 6. Atualiza a lista de pacotes do sistema
echo "Atualizando o cache do APT..."
apt update

echo "=== Processo concluído com sucesso! Snap removido e bloqueado. ==="