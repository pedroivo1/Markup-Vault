# Cachy OS

## Sys

run:
```bash
chmod +x *.sh
sudo setup.sh
```

## Apps

### fish

run:
```sh
nano ~/.config/fish/config.fish
```

past this content:
```sh
source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting

end
```
