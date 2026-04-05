# Fedora Setup

## System

### Update
```bash
sudo dnf upgrade --refresh -y
```

### Batery
```bash
ls /sys/class/power_supply/
ls /sys/class/power_supply/BAT0/charge_control_end_threshold
```

```bash
sudo nano /etc/systemd/system/battery-limit.service
```

```TOML
[Unit]
Description=Estabelece o limite maximo de carga da bateria
After=multi-user.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
ExecStart=/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
```

```bash
# Recarrega a lista de serviços do sistema
sudo systemctl daemon-reload

# Habilita o serviço para a próxima inicialização e o inicia agora
sudo systemctl enable --now battery-limit.service
```

## Apps
```bash
sudo dnf install $(cat apps.txt) --skip-unavailable -y
```

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.bitwarden.desktop -y
```


## Browser
```bash
sudo dnf install dnf-plugins-core
# Gemini alega que precisa desse comando, mas não está no site do brave
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo dnf install brave-browser
```

add bitwarden
make it the default password manager


## Links Simbólicos
```bash
# pegue o nome do disco em que a partição de dados está instalada
lsblk

sudo blkid <partição> # /dev/nvme0n1p2
sudo mkdir -p /mnt/data
sudo nano /etc/fstab
```

paste:
```bash
# Adicionar a seguinte linha (substituindo o UUID se necessário):
UUID=522cf738-6361-4162-a895-abd155df2674  /mnt/data  ext4  defaults  0  2
```

```bash
sudo systemctl daemon-reload
sudo mount -a

# Transferência da posse do disco para o usuário atual
sudo chown -R $USER:$USER /mnt/data

# Criação da infraestrutura de pastas no disco secundário
mkdir -p /mnt/data/Documents
mkdir -p /mnt/data/Downloads
mkdir -p /mnt/data/Music
mkdir -p /mnt/data/Pictures
mkdir -p /mnt/data/Videos

# Remoção dos diretórios originais vazios na pasta do usuário
rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos 2>/dev/null

# Criação das pontes de ligação definitivas
ln -sfn /mnt/data/Documents ~/Documents
ln -sfn /mnt/data/Downloads ~/Downloads
ln -sfn /mnt/data/Music ~/Music
ln -sfn /mnt/data/Pictures ~/Pictures
ln -sfn /mnt/data/Videos ~/Videos
```
