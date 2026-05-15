
### Install fish & tools
```sh
sudo apt update
sudo apt install -y fish
```

```sh
curl -sS https://starship.rs/install.sh | sh
```

### Install the Nerd Font (Crucial for Icons)
Do not use the standard APT package for FiraCode, as it lacks the icons. Download the patched version:

```sh
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip -d FiraCode
rm FiraCode.zip
fc-cache -fv
```

### Set Fish as Default in Konsole and Apply Font

1. If the Settings menu isn't at the top of the screen, press Ctrl+Shift+M.
2. Go to Settings -> Configure Konsole -> Profiles -> New (or edit your current one).
3. In the General tab, delete the current text (/bin/bash) and type the path to fish:

```text
/usr/bin/fish
```

4. Go to the Appearance tab, click Choose... under the Font section, and select FiraCode Nerd Font.
5. Click Apply -> OK -> Set as Default.
Apply->Ok->Set as Default

### Configure fish & Starship

1. Set up the fish config file:
```sh
mkdir -p ~/.config/fish
nano ~/.config/fish/config.fish
```

2. Paste the following configuration:
(Note: Use fish syntax, not toml for this file)

```toml
if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting

end


starship init fish | source

alias ls="ls --color=auto"
alias update="sudo apt update && sudo apt upgrade"

```

3. Apply the CachyOS/Nerd Font preset to Starship:

```sh
starship preset nerd-font-symbols -o ~/.config/starship.toml
```
