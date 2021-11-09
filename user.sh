#!/usr/bin/env bash

#-------------------------------------------------------------------------
# ______      _   _             ___           _
# | ___ \    | | | |           / _ \         | |
# | |_/ / ___| |_| |_ ___ _ __/ /_\ \_ __ ___| |__
# | ___ \/ _ \ __| __/ _ \ '__|  _  | '__/ __| '_ \
# | |_/ /  __/ |_| ||  __/ |  | | | | | | (__| | | |
# \____/ \___|\__|\__\___|_|  \_| |_/_|  \___|_| |_| v1.6
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
username=$(cat credentials.conf | awk -F "=" '{print $2}')

$ECHO "---------------------------------------"
$ECHO "==> This is the username: ${username}"
$ECHO "==> Changing directory to /home/${username}"
cd /home/${username}
$ECHO "---------------------------------------"
$ECHO "\n${GREEN}==> Installing AUR Helper\n${NC}" && $SLEEP

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
# 'franz-bin'
'github-desktop-bin' # Github Desktop sync ## It is in chaotic-aur ## maia helium
'google-chrome'
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
'plasma'
'plymouth'
'plymouth-theme-arch10'
'plymouth-theme-arch-charge-big'
'ocs-url' # install packages from websites
# 'sddm-nordic-theme-git'
# 'snapper-gui-git'
'spotify'
'sublime-text-4'
'ttf-cascadia-code'
'ttf-droid'
'ttf-hack'
'ttf-meslo' # Nerdfont package
'ttf-roboto'
'ttf-roboto-mono'
# 'ulauncher'
'visual-studio-code-bin' # visual studio code
'zoom' # video conferences
# 'snap-pac'
)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

export PATH=$PATH:~/.local/bin


# ------------------------------------------------------------------------### copied but not correctly pasted the contents
# adding neofetch to bashrc 
$ECHO "==> Adding neofetch in bashrc" && $SLEEP
$ECHO "neofetch" >> $HOME/.bashrc

$ECHO "==> Installing konsave using pip"
pip install konsave
# konsave -i $HOME/BetterArch/kde.knsv
$SLEEP
# konsave -a kde
exit
