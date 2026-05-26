#!/bin/bash

# Cores para o terminal
INFO="\033[0;36m"
SUCCESS="\033[0;32m"
RESET="\033[0m"

echo -e "${INFO}Atualizando pacotes e instalando o Fish e ferramentas necessárias...${RESET}"
sudo apt update
sudo apt install -y fish curl wget unzip fontconfig

echo -e "${INFO}Instalando o Starship...${RESET}"
# O comando é executado com flags para não pedir confirmação (Y/n) durante o script
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo -e "${INFO}Instalando a FiraCode Nerd Font...${RESET}"
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts || exit

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip -o FiraCode.zip -d FiraCode
rm FiraCode.zip
fc-cache -fv

# Volta para a pasta original
cd - > /dev/null

echo -e "${INFO}Configurando o Fish...${RESET}"
mkdir -p ~/.config/fish

# O bloco cat << 'EOF' cria o arquivo config.fish e insere o texto dentro dele automaticamente
cat << 'EOF' > ~/.config/fish/config.fish
if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting

end

starship init fish | source

alias ls="ls --color=auto"
alias update="sudo apt update && sudo apt upgrade"
EOF

echo -e "${INFO}Aplicando o preset Nerd Font Symbols no Starship...${RESET}"
# Executa o preset do starship e salva no starship.toml
starship preset nerd-font-symbols -o ~/.config/starship.toml

echo -e "${INFO}Definindo o Fish como o shell padrão (pode solicitar sua senha)...${RESET}"
sudo chsh -s "$(which fish)" "$(whoami)"

echo -e "${SUCCESS}==============================================${RESET}"
echo -e "${SUCCESS}Tudo pronto! Fish e Starship configurados com sucesso.${RESET}"
echo -e "${SUCCESS}Feche este terminal e abra um novo para usar o Fish.${RESET}"
echo -e "${SUCCESS}Lembre-se de mudar a fonte do seu emulador de terminal para 'FiraCode Nerd Font'.${RESET}"
echo -e "${SUCCESS}==============================================${RESET}"