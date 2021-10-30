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

$ECHO """${BLUE}
--------------------------------------
--          Network Setup           --
--------------------------------------
${NC}"""

# Enabling NetworkManager
$ECHO "${BLUE}==> Installing networkmanager dhclient${NC}"
$SLEEP
pacman -S networkmanager dhclient --noconfirm --needed
$ECHO "${BLUE}==> Enabling service NetworkManager${NC}"
$SLEEP
systemctl enable --now NetworkManager

$ECHO "-------------------------------------------------"
$ECHO "Setting up mirrors for optimal download          "
$ECHO "-------------------------------------------------"
$SLEEP
pacman -S --noconfirm pacman-contrib curl reflector rsync
$SLEEP

$ECHO "==> Creating a backup for mirrorlist"
$SLEEP
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
$SLEEP
nc=$(grep -c ^processor /proc/cpuinfo)
$ECHO "==> You have " $nc" cores.\n"
$ECHO "-------------------------------------------------"
$ECHO "==> Changing the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')

if [[  $TOTALMEM -gt 8000000 ]]; then
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
    $ECHO "==> Changing the compression settings for "$nc" cores."
    sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf
fi


$ECHO "${BLUE}
-------------------------------------------------
--     Setup Language to US and set locale     --
-------------------------------------------------
${NC}"
sleep 0.5

$ECHO "${GREEN}==> Setting up locales${NC}"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

$ECHO "${GREEN}==> Setting Timezone${NC}"
timedatectl --no-ask-password set-timezone Asia/Kolkata
timedatectl --no-ask-password set-ntp 1

$ECHO "${GREEN}==> Setting Language to US (Default)${NC}"
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

# Set keymaps
$ECHO "${GREEN}==> Setting keymaps${NC}"
sleep 0.5
localectl --no-ask-password set-keymap us

# Add sudo no password rights
sleep 0.5
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
$ECHO "${GREEN}==> Adding parallel downloads in pacman config${NC}"
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib support
$ECHO "${GREEN}==> Enabling multilib support in pacman config${NC}"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

$ECHO "${GREEN}\n==> Started Installing Base System\n${NC}"

PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-apps'
'xorg-drivers'
'xorg-xkill'
'xorg-xinit'
'xterm'
'plasma-desktop' # KDE Load second
'alsa-plugins' # audio plugins
'alsa-utils' # audio utils
'ark' # compression
'audiocd-kio' 
'autoconf' # build
'automake' # build
'base'
'bash-completion'
'bc'
'bind'
'binutils'
'bison'
'bitwarden'
'bluedevil'
'bluez' # bluetooth
'bluez-libs'
'breeze'
'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'celluloid' # video players
'cmatrix'
'code' # Visual Studio code
'cronie'
'cups' # Printer
'dialog'
'discover' # Software center
'dolphin'
'dosfstools'
'dsniff'
'efibootmgr' # EFI boot
'egl-wayland'
'exfat-utils'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gamemode'
'gcc' # Compiler
'gimp' # Photo editing
'git'
'gparted' # partition management
'gptfdisk'
'grub'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
'kate'
'kvantum-qt5'
'kde-gtk-config'
'kitty'
'konsole'
'layer-shell-qt'
'libnewt'
'libtool'
'linux'
'linux-firmware'
'linux-headers'
'lsof'
'lutris'
'lzop'
'm4'
'make'
'milou'
'nano'
'neofetch'
'networkmanager'
'net-tools'
'nmap'
'ntfs-3g'
'ntp'
'okular'
'openbsd-netcat'
'openssh'
'os-prober'
'oxygen'
'p7zip'
'pacman-contrib'
'patch'
'picom'
'pkgconf'
'plasma-nm'
'powerline-fonts'
'print-manager'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python-pip'
'qemu'
'rsync'
'sddm'
'sddm-kcm'
'snapper'
'spectacle'
'steam'
'sudo'
'swtpm'
'synergy'
'systemsettings'
'telegram-desktop' # Instant messaging
'terminus-font'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'vim'
# 'virt-manager'
# 'virt-viewer'
'wget'
'which'
'wine-gecko'
'wine-mono'
'winetricks'
'wireguard-tools'
'xdg-desktop-portal-kde'
'xdg-user-dirs'
'zeroconf-ioslave'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
)

for PKG in "${PKGS[@]}"; do
    $ECHO "${GREEN}[+] Installing: ${PKG}${NC}"
    sleep 0.5
    sudo pacman -S "$PKG" --noconfirm --needed
done


# determine processor type and install microcode
# 
$ECHO "==> Detecting Processor Type"
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
        $ECHO "==> $proc_type Detected"
		$ECHO "==> Installing Intel microcode"
		sleep 0.5
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
        $ECHO "$proc_type Detected"
		$ECHO "==> Installing AMD microcode"
		sleep 0.5
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

$ECHO "${GREEN}\n[+] Done !\n${NC}"
sleep 2

if ! source install.conf; then
	$READ "[+] Enter the Username: " username
    $ECHO "username=$username" >> ${HOME}/ArchTitus/install.conf
fi

if [ $(whoami) = "root"  ];
then
    $ECHO "${GREEN}==> Addding User $username ${NC}"
    sleep 1
    useradd -m -G wheel,libvirt -s /bin/bash $username
	passwd $username
	$ECHO "==> Copying ArchTitus to home"
	cp -R /root/ArchTitus /home/$username/
	$ECHO "==> Changing ArchTitus/ permission as $username"
    chown -R $username: /home/$username/ArchTitus
	$READ "[+] Enter the hostname: " nameofmachine
	$ECHO $nameofmachine > /etc/hostname
else
	$ECHO "${RED}==> You are already a user proceed with aur installs${NC}"
fi

