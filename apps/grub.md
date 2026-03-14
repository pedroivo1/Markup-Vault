# GRUB

### Set actual sys as default GRUB
```sh
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=CachyOS_LTS
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Update GRUB settings
```sh
sudo nano /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
