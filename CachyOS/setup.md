# CachyOS Setup Guide

## 1. General Aplicarions

```bash
sudo pacman -Syu

# desenvolvimento
sudo pacman --needed -S paru github-cli npm vscodium claude-desktop

# navegadores
sudo pacman --needed -S brave-origin-bin zen-browser

# terminal
sudo pacman --needed -S kitty alacritty konsole fish cachyos-fish-config cachyos-zsh-config

# escritorio
sudo pacman --needed -S libreoffice-fresh libreoffice-fresh-pt-br okular kwrite

# midia
sudo pacman --needed -S audacity kamoso haruna yt-dlp

# sistema
sudo pacman --needed -S ntfs-3g
```

```bash
# desenvolvimento (AUR)
paru --needed -S visual-studio-code-bin unityhub

# navegadores (AUR)
paru --needed -S google-chrome
```


## 2. Git

```bash
git config --global user.name "pedroivo1"
git config --global user.email "pedroivoal1@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
```

```bash
gh auth login
```


## 3. Battery & SSD

### Battery Charge Limit

```bash
sudo nano /etc/systemd/system/battery-charge-threshold.service
```

```toml
[Unit]
Description=Set battery charge limit to 80%
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now battery-charge-threshold.service
```

### SSD Trim Optimization

```bash
sudo systemctl enable --now fstrim.timer
```


## 4. Storage and Symbolic Links

```bash
sudo chown -R $USER:$USER /data

mkdir -p /data/Documents
mkdir -p /data/Downloads
mkdir -p /data/Music
mkdir -p /data/Pictures
mkdir -p /data/Videos
mkdir -p /data/AI
mkdir -p /data/Applications

rmdir ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos ~/AI ~/Applications 2>/dev/null

ln -sfn /data/Documents ~/Documents
ln -sfn /data/Downloads ~/Downloads
ln -sfn /data/Music ~/Music
ln -sfn /data/Pictures ~/Pictures
ln -sfn /data/Videos ~/Videos
ln -sfn /data/AI ~/AI
ln -sfn /data/Applications ~/Applications
```

## 5. Browser cache

```bash
nano ~/.local/bin/browser-ram-cache
```

```sh
#!/bin/sh
ram=/dev/shm/browser-cache
mkdir -p "$ram/brave-http" "$ram/chrome-http" "$ram/zen-http"

up() {
  ps -C "$1" -o pid= >/dev/null 2>&1
}

link_dir() {
  src=$1
  dest=$2
  mkdir -p "$dest"
  if [ -L "$src" ]; then
    if [ "$(readlink "$src")" = "$dest" ]; then
      return 0
    fi
    rm -f "$src"
  elif [ -e "$src" ]; then
    rm -rf "$src"
  fi
  ln -s "$dest" "$src"
}

if ! up brave; then
  link_dir "$HOME/.cache/BraveSoftware" "$ram/BraveSoftware"
  bcfg="$HOME/.config/BraveSoftware/Brave-Origin"
  if [ -d "$bcfg/Default" ]; then
    link_dir "$bcfg/Default/GPUCache" "$ram/brave-gpu/Default-GPUCache"
    link_dir "$bcfg/Default/DawnGraphiteCache" "$ram/brave-gpu/DawnGraphiteCache"
    link_dir "$bcfg/Default/DawnWebGPUCache" "$ram/brave-gpu/DawnWebGPUCache"
  fi
  if [ -d "$bcfg/GPUPersistentCache" ] || [ -L "$bcfg/GPUPersistentCache" ]; then
    link_dir "$bcfg/GPUPersistentCache" "$ram/brave-gpu/GPUPersistentCache"
  fi
fi

if ! up chrome; then
  link_dir "$HOME/.cache/google-chrome" "$ram/google-chrome"
  ccfg="$HOME/.config/google-chrome"
  if [ -d "$ccfg/Default" ]; then
    link_dir "$ccfg/Default/GPUCache" "$ram/chrome-gpu/Default-GPUCache"
    link_dir "$ccfg/Default/DawnGraphiteCache" "$ram/chrome-gpu/DawnGraphiteCache"
    link_dir "$ccfg/Default/DawnWebGPUCache" "$ram/chrome-gpu/DawnWebGPUCache"
  fi
  if [ -d "$ccfg/GPUPersistentCache" ] || [ -L "$ccfg/GPUPersistentCache" ]; then
    link_dir "$ccfg/GPUPersistentCache" "$ram/chrome-gpu/GPUPersistentCache"
  fi
fi

if ! up zen-bin && ! up zen; then
  link_dir "$HOME/.cache/zen" "$ram/zen"
fi
```

```bash
chmod +x ~/.local/bin/browser-ram-cache
```

```bash
nano ~/.config/plasma-workspace/env/browser-ram-cache.sh
```

```sh
#!/bin/sh
"$HOME/.local/bin/browser-ram-cache" >/dev/null 2>&1 || true
```

```bash
nano ~/.config/brave-origin-flags.conf
```

```text
--disk-cache-dir=/dev/shm/browser-cache/brave-http
--disk-cache-size=314572800
--disable-gpu-shader-disk-cache
```

```bash
nano ~/.config/chrome-flags.conf
```

```text
--disk-cache-dir=/dev/shm/browser-cache/chrome-http
--disk-cache-size=314572800
--disable-gpu-shader-disk-cache
```

```bash
nano ~/.config/zen/6ge7mz6w.Default\ \(release\)/user.js
```

```js
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.capacity", 307200);
user_pref("browser.cache.disk.parent_directory", "/dev/shm/browser-cache/zen-http");
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", 262144);
```
