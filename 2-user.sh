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
'github-desktop-bin' # Github Desktop sync
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
'sddm-nordic-theme-git'
# 'snapper-gui-git'
'ttf-cascadia-code'
'ttf-droid'
'ttf-hack'
'ttf-meslo' # Nerdfont package
'ttf-roboto'
'ttf-roboto-mono'
'ulauncher'
'zoom' # video conferences
# 'snap-pac'
)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

export PATH=$PATH:~/.local/bin
# $ECHO "==> Copying dotfiles"
# cp -r $HOME/BetterArch/dotfiles/* $HOME/.config/
$ECHO "==> Installing konsave using pip"
pip install konsave
konsave -i $HOME/BetterArch/kde.knsv
$SLEEP
konsave -a kde
$ECHO "==> Adding neofetch in bashrc" && $SLEEP
$ECHO "neofetch" >> $HOME/.bashrc
$ECHO "==> Adding config to home" && $SLEEP
cp -r $HOME/BetterArch/config/* / $HOME/.config/ && $ECHO "${GREEN}\n[+] Done with config!\n${NC}" || $ECHO "==> Directory not found. creating one" && mkdir $HOME/.config/ && cp -r $HOME/BetterArch/config/* $HOME/.config/
$ECHO "==> Adding local to home" && $SLEEP
cp -r $HOME/BetterArch/local/* $HOME/.local/ && $ECHO "${GREEN}\n[+] Done with config!\n${NC}"  || $ECHO "==> Directory not found. creating one" && mkdir $HOME/.local/ && cp -r $HOME/BetterArch/local/* $HOME/.local/
$ECHO "==> Adding usr dir for sddm theme" && $SLEEP
cp -r $HOME/BetterArch/usr/share/sddm/themes/* /usr/share/sddm/themes/ && $ECHO "${GREEN}\n[+] Done with sddm theme [Orchis]!\n${NC}" && $SLEEP
$ECHO "==> Adding etc dir for sddm config" && $SLEEP
cp -r $HOME/BetterArch/etc/sddm.conf.d/* /etc/sddm.conf.d  && $ECHO "${GREEN}\n[+] Done with sddm config!\n${NC}" && $SLEEP || $ECHO "==> Directory not found. creating one" && mkdir /etc/sddm.conf.d/ && cp -r $HOME/BetterArch/etc/sddm.conf.d/* /etc/sddm.conf.d && $ECHO "${GREEN}\n[+] Done with sddm config!\n${NC}" && $SLEEP
$ECHO "${GREEN}\n[+] Done with user!\n${NC}"
exit
