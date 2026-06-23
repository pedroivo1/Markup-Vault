## 1. Bloquear os módulos da placa (Modprobe)
```sh
sudo nano /etc/modprobe.d/blacklist-nvidia.conf
```

```text
blacklist nouveau
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
blacklist nvidia_uvm
blacklist ipmi_msghandler
blacklist ipmi_devintf
options nouveau modeset=0
```

## 2. Isolar a placa do barramento PCI (Udev)
```sh
sudo nano /etc/udev/rules.d/10-remove-nvidia.rules
```

```text
ACTION=="add", KERNEL=="<seu_endereco>", SUBSYSTEM=="pci", ATTR{remove}="1"
```

## 3. Configurar os parâmetros de inicialização (GRUB)
```sh
sudo nano /etc/default/grub
```

```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pcie_port_pm=force nouveau.modeset=0 nvidia-drm.modeset=0 module_blacklist=nvidia,nouveau"
```

## 4. Aplicar as configurações no sistema
```sh
sudo update-initramfs -u
```

```sh
sudo update-grub
```

## 5. Finalizar
```sh
reboot
```
