echo "options rtw88_core disable_aspm=y" | sudo tee /etc/modprobe.d/rtw88.conf
sudo modprobe -r rtw88_8821ce
sudo modprobe rtw88_8821ce

# yay -S rtl8821ce-dkms-git
# sudo modprobe -r rtw88_8821ce
# sudo modprobe 8821ce
