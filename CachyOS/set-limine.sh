sudo efibootmgr -o 0001,0000

sudo efibootmgr -o 0000,0001,0002

sudo nano /boot/limine.conf

# /Ubuntu
#     protocol: efi_chainload
#     image_path: boot():/EFI/UBUNTU/SHIMX64.EFI
