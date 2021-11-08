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
GREEN="\e[32m"
ORANGE="\e[33m"
ECHO="echo -e"
READ="read -p"
SLEEP="sleep 0.5"
username=$(cat credentials.conf | awk -F "=" '{print $2}')

$ECHO "\n==> Reached Final setup and configuration"

function addTweaks() {
    $ECHO "Username = `whoami`"
    $ECHO "Home directory : $(pwd)"
    $ECHO "==> Username = $(whoami)"
    cd ~
    $ECHO "${GREEN}==> Attempting to add custom tweaks${NC}"
    $ECHO "==> Copying config files"
    mkdir -p $HOME/.config
    cp -R $HOME/BetterArch/config/* $HOME/.config/
    chown -R ${username} $HOME/.config/
    $SLEEP
    # usr/share ----------------------------------------------------
    $ECHO "==> Copying wallpapers, konsole themes and sddm themes to /usr/share/"
    mkdir -p /usr/share/wallpapers/
    sleep 10
    cp -R $HOME/BetterArch/usr/share/* /usr/share/
    $SLEEP
    # Copying sddm settings conf ---------------------------------------------
    $ECHO "==> Copying sddm settings conf /etc/sddm.conf.d/"
    cp -R $HOME/BetterArch/etc/sddm.conf.d/* /etc/
    $SLEEP
    # Konsole profile added (local) ----------------------------------------------------
    $ECHO "==> Copying konsole profile"
    cp -R $HOME/BetterArch/local/* $HOME/.local/
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
    # ------------------------------------------------------------------------
    $ECHO "==> Copying face icon and gtkrc to home"
    cp -R $HOME/BetterArch/etc/skel/* $HOME
    $SLEEP
    $ECHO "${GREEN}[+] Process is done !${NC}"
}

$ECHO "==> This is the Username from credentials.conf. user = '${username}'"
$ECHO "==> Now It is going to switch user for adding some custom tweaks to that user ${username}"
$READ "==> Switching to User $USER to ${username}. If you wish? [y/n] " usercheck
if [[ $usercheck == "y" ]]; then
    $ECHO "==> switching to user ${username}"
    export -f addTweaks
    su ${username} -c "bash -c addTweaks"
    $ECHO "==> Switching back to root"
elif [[ $usercheck == "n" ]]; then
    $ECHO "${RED}==> Oops, sorry you can't get the custom tweaks !"
else
    $ECHO "${RED}==> Oops, sorry you can't get the custom tweaks !"
fi

$ECHO "Home directory : $(pwd)"
$ECHO "==> Username = $(whoami)"
cd ~
sleep 5

# ------------------------------------------------------------------------

$ECHO "${GREEN}==> Adding custom progress bar theme to pacman${NC}"
sed -i '/ParallelDownloads = 8/a ILoveCandy' /etc/pacman.conf
$ECHO "${GREEN}==> Enabling color in pacman${NC}"
sed -i 's/#Color/Color/' /etc/pacman.conf

# ------------------------------------------------------------------------

$ECHO "${ORANGE}==> Adding chaotic-aur${NC}"
$ECHO "${ORANGE}==> Receiving the keys from the keyserver${NC}"
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
$ECHO "${ORANGE}==> Signing the key${NC}"
pacman-key --lsign-key 3056513887B78AEB
$ECHO "${ORANGE}==> Installing chaotic-keyring and mirrorlist${NC}"
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
$ECHO "${ORANGE}==> Adding chaotic-aur repository to pacman config${NC}"
$ECHO "" >> /etc/pacman.conf
$ECHO "[chaotic-aur]" >> /etc/pacman.conf
$ECHO "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
$ECHO ${ORANGE}"==> Updating the System${NC}"
pacman -Syyu --noconfirm
$ECHO "${GREEN}==> System updated${NC}"



# ------------------------------------------------------------------------
$ECHO "${GREEN}\n[+] Installing grub${NC}"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

$ECHO "${GREEN}\n[+] Generating grub configuration${NC}"
mkdir -p /boot/grub/
grub-mkconfig -o /boot/grub/grub.cfg

$ECHO "==> Changing values in grub and regenerating grub"
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash"/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0"/' /etc/default/grub
sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080/' /etc/default/grub
sed -i 's/#GRUB_SAVEDEFAULT=true/GRUB_SAVEDEFAULT=saved/' /etc/default/grub
sed -i 's/#GRUB_DISABLE_SUBMENU=y/GRUB_DISABLE_SUBMENU=y/' /etc/default/grub
$ECHO "" >> /etc/default/grub
$ECHO "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

# ------------------------------------------------------------------------

$ECHO "${GREEN}\n[+] Setting up plymouth Theme${NC}"
plymouth-set-default-theme -R arch10

# ------------------------------------------------------------------------

$ECHO "${GREEN}\n[+] Adding modules and hooks to mkinitcpio.conf${NC}"
sed -i 's/MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
sed -i 's/^HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev plymouth autodetect modconf block filesystems keyboard fsck)/' /etc/mkinitcpio.conf
$ECHO "==> This is the HOOKS return value $?" && $SLEEP

$ECHO "${GREEN}\n[+] Changing ShowDelay value in plymouthd.conf${NC}"
sed -i 's/^ShowDelay=/ShowDelay=0/' /etc/plymouth/plymouthd.conf
sed -i 's/^DeviceTimeout=/DeviceTimeout=5/' /etc/plymouth/plymouthd.conf
mkinitcpio -p linux-lts

# ------------------------------------------------------------------------

$ECHO "${GREEN}\n[+] Setting up SDDM Theme${NC}"
sudo cat <<EOF > /etc/sddm.conf
[Theme]
Current=Orchis
EOF

# ------------------------------------------------------------------------

$ECHO "${GREEN}\n[+] Enabling Login Display Manager${NC}"

sudo systemctl enable sddm-plymouth.service

# ------------------------------------------------------------------------

$ECHO "${GREEN}\n[+] Enabling essential services${NC}"

systemctl enable cups.service && $SLEEP
ntpd -qg && $SLEEP
systemctl enable ntpd.service && $SLEEP
systemctl stop dhcpcd.service && $SLEEP
systemctl enable NetworkManager.service && $SLEEP
systemctl enable bluetooth && $SLEEP

# ------------------------------------------------------------------------

$ECHO "
###############################################################################
# Cleaning
###############################################################################
"
# Remove no password sudo permissions
$ECHO "${RED}[!] Removing no password permissions${NC}"
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# Add sudo permissions
$ECHO "${GREEN}[+] Adding sudo permissions to ${username}${NC}"
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

$ECHO "
###############################################################################
# Done - Please Eject Install Media and Reboot
###############################################################################
"
