#!/usr/bin/env bash

#-------------------------------------------------------------------------
# ______      _   _             ___           _
# | ___ \    | | | |           / _ \         | |
# | |_/ / ___| |_| |_ ___ _ __/ /_\ \_ __ ___| |__
# | ___ \/ _ \ __| __/ _ \ '__|  _  | '__/ __| '_ \
# | |_/ /  __/ |_| ||  __/ |  | | | | | | (__| | | |
# \____/ \___|\__|\__\___|_|  \_| |_/_|  \___|_| |_| v1.4
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

$ECHO ${username}

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
# 'franz-bin'
'github-desktop-bin' # Github Desktop sync
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
'plasma-pa'
'plymouth'
'plymouth-theme-arch10'
'plymouth-theme-arch-charge'
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

$ECHO "==> Copying config files"
mkdir -p $HOME/.config
cp -R $HOME/BetterArch/config/* $HOME/.config/
chown -R ${username} $HOME/.config/
$SLEEP
# usr/share ---------------------------------------------------- ###
$ECHO "==> Copying wallpapers, konsole themes and sddm themes to /usr/share/"
mkdir -p /usr/share/wallpapers/
sleep 10
cp -R $HOME/BetterArch/usr/share/* /usr/share/
$SLEEP
# Copying sddm settings conf ---------------------------------------------###
$ECHO "==> Copying sddm settings conf /etc/sddm.conf.d/"
cp -R $HOME/BetterArch/etc/sddm.conf.d/ /etc/
$SLEEP
# Konsole profile added (local) ---------------------------------------------------- ###
$ECHO "==> Copying konsole profile"
cp -R $HOME/BetterArch/local/share/ $HOME/.local/
chown -R ${username} $HOME/.local/
$SLEEP
# Eagle profile img added -------------------------------------------------
# $ECHO "==> Copying profile img to /usr/share/sddm/faces/"
# cp -R $HOME/BetterArch/etc/skel/eagle.png /usr/share/sddm/faces/
# $SLEEP
# renaming the user icon in /usr/share/sddm/faces/------------------------
# $ECHO "==> Renaming to user.face.icon"
# mv /usr/share/sddm/faces/eagle.png /usr/share/sddm/faces/user.face.icon
# $SLEEP
# ------------------------------------------------------------------------###
$ECHO "==> Copying face icon and gtkrc to home"
cp -R $HOME/BetterArch/etc/skel/* $HOME
$SLEEP
# Renaming user icon to .face---------------------------------------------
$ECHO "==> Renaming to .face.icon"
mv $HOME/eagle.png $HOME/.face.icon
$SLEEP
# ------------------------------------------------------------------------### copied but not correctly pasted the contents
# adding neofetch to bashrc 
$ECHO "==> Adding neofetch in bashrc" && $SLEEP
$ECHO "neofetch" >> $HOME/.bashrc

# $ECHO "==> Installing konsave using pip"
# pip install konsave
# konsave -i $HOME/BetterArch/kde.knsv
# $SLEEP
# konsave -a kde
exit
