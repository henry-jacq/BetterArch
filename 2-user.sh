#!/usr/bin/env bash

#-------------------------------------------------------------------------
# ______      _   _             ___           _
# | ___ \    | | | |           / _ \         | |
# | |_/ / ___| |_| |_ ___ _ __/ /_\ \_ __ ___| |__
# | ___ \/ _ \ __| __/ _ \ '__|  _  | '__/ __| '_ \
# | |_/ /  __/ |_| ||  __/ |  | | | | | | (__| | | |
# \____/ \___|\__|\__\___|_|  \_| |_/_|  \___|_| |_| v1.0
#-------------------------------------------------------------------------
# Author: Henry
# GitHub: https://github.com/henry-jacq
# Info: This setup is still in beta stage

NC="\e[0m"
RED="\e[31m"
BLUE="\e[34m"
GREEN="\e[32m"
ORANGE="\e[33m"
ECHO="echo -e"
READ="read -p"
SLEEP="sleep 0.5"


$ECHO "\n${GREEN}==> Installing AUR Helper\n${NC}" && $SLEEP
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

$ECHO "${GREEN}==> Cloning: Yay${NC}" && $SLEEP
cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ${HOME}/yay
makepkg -si --noconfirm
cd ~
# touch "$HOME/.cache/zshhistory"
# git clone "https://github.com/ChrisTitusTech/zsh"
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
# ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc

PKGS=(
'autojump'
'awesome-terminal-fonts'
'brave-bin' # Brave Browser
'discord' #discord
# 'dxvk-bin' # DXVK DirectX to Vulcan
'franz-bin'
'github-desktop-bin' # Github Desktop sync
'koko'
'lightly-git'
# 'mangohud' # Gaming FPS Counter
# 'mangohud-common'
'nerd-fonts-fira-code'
# 'nordic-darker-standard-buttons-theme'
# 'nordic-darker-theme'
# 'nordic-kde-git'
# 'nordic-theme'
'noto-fonts-emoji'
'papirus-icon-theme'
'plasma-pa'
'ocs-url' # install packages from websites
# 'sddm-nordic-theme-git'
# 'snapper-gui-git'
'sublime-text-4'
'ttf-cascadia-code'
'ttf-droid'
'ttf-hack'
'ttf-meslo' # Nerdfont package
'ttf-roboto'
'ttf-roboto-mono'
'ulauncher'
'visual-studio-code-bin' # visual studio code
'zoom' # video conferences
# 'snap-pac'
)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

export PATH=$PATH:~/.local/bin
# $ECHO "==> Copying dotfiles"
# cp -r $HOME/BetterArch/dotfiles/* $HOME/.config/

$ECHO "==> Copying config"
mkdir -p $HOME/.config
cp -r $HOME/BetterArch/config/* $HOME/.config/
chown -R ${username} $HOME/.config/

$ECHO "==> Copying /usr/share/wallpapers/"
if [[ -d /usr/share/wallpapers/ ]]; then
    cp -r $HOME/BetterArch/local/* /usr/share/wallpapers/
    # chown -R ${username} /usr/share/wallpapers/
else
    mkdir -p /usr/share/wallpapers/
    cp -r $HOME/BetterArch/local/* /usr/share/wallpapers/
fi

$ECHO "==> Copying /usr/share/"
sudo cp -r $HOME/BetterArch/usr/share/konsole /usr/share/
sudo cp -r $HOME/BetterArch/usr/share/sddm/themes/Orchis/ /usr/share/sddm/themes/

$ECHO "==> Copying /etc/sddm.conf.d/"
sudo cp -r $HOME/BetterArch/etc/sddm.conf.d/ /etc/


$ECHO "==> Installing konsave using pip"
pip install konsave
konsave -i $HOME/BetterArch/kde.knsv
$SLEEP
konsave -a kde
sleep 10
# ----------------------------------------------------------------
$ECHO "==> Adding neofetch in bashrc" && $SLEEP
$ECHO "neofetch" >> $HOME/.bashrc
# ----------------------------------------------------------------
# $ECHO "==> Adding config to home" && $SLEEP
# sudo cp -r $HOME/BetterArch/config/* / $HOME/.config/ && $ECHO "${GREEN}\n[+] Done with config!\n${NC}" || $ECHO "==> Directory not found. creating one" && mkdir -p $HOME/.config/ && cp -r $HOME/BetterArch/config/* $HOME/.config/
# # ----------------------------------------------------------------
# $ECHO "==> Adding local to home" && $SLEEP
# sudo cp -r $HOME/BetterArch/local/* $HOME/.local/ && $ECHO "${GREEN}\n[+] Done with config!\n${NC}" || $ECHO "==> Directory not found. creating one" && mkdir -p $HOME/.local/ && cp -r $HOME/BetterArch/local/* $HOME/.local/
# # ----------------------------------------------------------------
# $ECHO "==> Adding usr dir for sddm theme" && $SLEEP
# sudo cp -r $HOME/BetterArch/usr/share/sddm/themes/* /usr/share/sddm/themes/ && $ECHO "${GREEN}\n[+] Done with sddm theme [Orchis]!\n${NC}" || mkdir -p /usr/share/sddm/themes/ && sudo cp -r $HOME/BetterArch/usr/share/sddm/themes/* /usr/share/sddm/themes/ && $ECHO "${GREEN}\n[+] Done with sddm theme [Orchis]!\n${NC}"
# # ----------------------------------------------------------------
# $ECHO "==> Adding etc dir for sddm config" && $SLEEP
# sudo cp -r $HOME/BetterArch/etc/sddm.conf.d/* /etc/sddm.conf.d/  && $ECHO "${GREEN}\n[+] Done with sddm config!\n${NC}" || mkdir -p /etc/sddm.conf.d/ && sudo cp -r $HOME/BetterArch/etc/sddm.conf.d/* /etc/sddm.conf.d/  && $ECHO "${GREEN}\n[+] Done with sddm config!\n${NC}"
# # || $ECHO "==> Directory not found. creating one" && mkdir /etc/sddm.conf.d/ && cp -r $HOME/BetterArch/etc/sddm.conf.d/* /etc/sddm.conf.d/ && $ECHO "${GREEN}\n[+] Done with sddm config!\n${NC}" && $SLEEP
# # ----------------------------------------------------------------
# $ECHO "${GREEN}\n[+] Done with user!\n${NC}"
exit
