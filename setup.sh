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

$ECHO "
--------------------------------------
--          Network Setup           --
--------------------------------------"

# Enabling NetworkManager
$ECHO "${BLUE}==> Installing networkmanager dhclient${NC}"
$SLEEP
pacman -S networkmanager dhclient --noconfirm --needed
$ECHO "${BLUE}==> Enabling service NetworkManager${NC}"
$SLEEP
systemctl enable --now NetworkManager

$ECHO "
-------------------------------------------------
---- Setting up mirrors for optimal download ----
-------------------------------------------------" && $SLEEP

pacman -S --noconfirm pacman-contrib curl reflector rsync
$SLEEP

$ECHO "==> Creating a backup for pacman mirrorlist"
$SLEEP
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
$SLEEP

# Checking Processor info
prc=$(grep -c ^processor /proc/cpuinfo)
$ECHO "==> You have " $prc" cores.\n"

$ECHO "-------------------------------------------------"
$ECHO "==> Changing the makeflags for "$prc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')

if [[  $TOTALMEM -gt 8000000 ]]; then
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
    $ECHO "==> Changing the compression settings for "$prc" cores."
    sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf
fi


$ECHO "
-------------------------------------------------
--     Setup Language to US and set locale     --
-------------------------------------------------"
$SLEEP

$ECHO "${GREEN}==> Setting up locales${NC}" && $SLEEP
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
$ECHO "${GREEN}==> Generating locales${NC}" && $SLEEP
locale-gen

$ECHO "${GREEN}==> Setting Timezone${NC}" && $SLEEP
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
timedatectl --no-ask-password set-timezone Asia/Kolkata
timedatectl --no-ask-password set-ntp 1

$ECHO "${GREEN}==> Setting Language to US (Default)${NC}" && $SLEEP
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

# Set keymaps
$ECHO "${GREEN}==> Setting keymaps${NC}" && $SLEEP
localectl --no-ask-password set-keymap us

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# Add parallel downloads
$ECHO "${GREEN}==> Adding parallel downloads in pacman config${NC}" && $SLEEP
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 8/' /etc/pacman.conf

# Enable multilib support
$ECHO "${GREEN}==> Enabling multilib repo support in pacman config${NC}" && $SLEEP
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
$ECHO "==> Updating the system" && $SLEEP
pacman -Sy --noconfirm

$ECHO "${GREEN}\n[+] Started Installing Base System\n${NC}" && $SLEEP

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
'blueberry'
'bluez-firmware'
# 'breeze'
# 'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'celluloid' # video players
'cmatrix'
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
'firefox'
'flameshot'
'flex'
'fuse2'
'fuse3'
'fuseiso'
# 'gamemode'
'gcc' # Compiler
'gimp' # Photo editing
'git'
'gparted' # partition management
'gptfdisk'
'grub'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'gufw'
'haveged'
'hplip'
'htop'
'iptables-nft'
# 'jdk-openjdk' # Java 17
'kate'
'kvantum-qt5'
'kdeconnect'
'kde-gtk-config'
'konsole'
'ktorrent'
'layer-shell-qt'
'latte-dock'
'libnewt'
'libtool'
'linux-lts'
'linux-firmware'
'linux-lts-headers'
# 'linux-zen'
'lsof'
'lutris'
'lzop'
'm4'
'make'
'milou'
'mlocate'
'nano'
'neofetch'
'networkmanager'
'networkmanager-openvpn'
'networkmanager-vpnc'
'network-manager-applet'
'net-tools'
'nmap'
'nodejs'
'npm'
'npm-check-updates'
'ntfs-3g'
'ntp'
'okular'
'openbsd-netcat'
'openssh'
'os-prober'
'p7zip'
'pacman-contrib'
'packagekit-qt5'
'patch'
'picom'
'pkgconf'
'plasma-nm'
'powerline-fonts'
'powerpill'
'print-manager'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python-pip'
'rsync'
'sddm'
'sddm-kcm'
'snapper'
'spectacle'
'sudo'
'swtpm'
'sweet-gtk-theme'
'sweet-gtk-theme-dark'
'sweet-kde-git'
'sweet-theme-git'
'synergy'
'systemsettings'
'telegram-desktop' # Instant messaging
'terminus-font'
'thunderbird'
'timeshift'
'traceroute'
'ttf-fira-sans'
'ufw'
'unrar'
'unzip'
'update-grub'
'usbutils'
'vim'
'virtualbox'
'virtualbox-guest-iso'
'virtualbox-guest-utils'
'virtualbox-host-modules-arch'
'vlc'
'volumeicon'
# 'virt-manager'
# 'virt-viewer'
'wget'
'which'
# 'wine-gecko'
# 'wine-mono'
# 'winetricks'
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
    $SLEEP
    pacman -S "$PKG" --noconfirm --needed
done

updatedb

pacman -S intel-ucode intel-gpu-tools intel-graphics-compiler intel-media-driver intel-media-sdk --noconfirm --needed

# Determine processor type and install microcode
$ECHO "==> Detecting Processor Type"

proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
        $ECHO "==> $proc_type Detected"
		$ECHO "==> Installing Intel microcode" && $SLEEP
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
        $ECHO "$proc_type Detected"
		$ECHO "==> Installing AMD microcode" && $SLEEP
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    $ECHO "==> Installing NVIDIA driver" && $SLEEP
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    $ECHO "==> Installing AMD Radeon driver" && $SLEEP
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    $ECHO "==> Installing driver for Integrated Graphics Controller" && $SLEEP
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

$ECHO "${GREEN}\n[+] Done !\n${NC}"
sleep 2

$READ "[+] Enter the Username: " username
$ECHO "username=${username}" >> ${HOME}/BetterArch/install.conf

if [ $(whoami) = "root"  ]; then
    $ECHO "${GREEN}==> Addding User $username ${NC}"
    $SLEEP
    $ECHO "==> This is the username ${username}"
    $SLEEP
    $READ "[?] want to continue [y/n] " answer
    $SLEEP
    if [ $answer == "y" ]; then
    	useradd -m -G wheel -s /bin/bash ${username}
    	$ECHO "==> Prompting For Password"
    	$SLEEP
    	passwd ${username}
    	$ECHO "==> Copying BetterArch to home"
    	cp -R /root/BetterArch/ /home/${username}/
    	$ECHO "==> Changing BetterArch/ folder permission as "${username}" this user"
    	chown -R ${username}: /home/${username}/BetterArch
    	$READ "[+] Enter the Hostname: " nameofmachine
    	$ECHO ${nameofmachine} > /etc/hostname && $ECHO "==> Hostname Added !"
        export $nameofmachine
        export $username
    elif [ $answer == "n" ]; then
    	$ECHO "If statement process echoed into new file called if-stop.sh"
        cat < EOF >> if-stop.sh
        useradd -m -G wheel -s /bin/bash ${username}
            $ECHO "==> Prompting For Password"
            $SLEEP
            passwd ${username}
            $ECHO "==> Copying BetterArch to home"
            cp -R /root/BetterArch/ /home/${username}/
            $ECHO "==> Changing BetterArch/ folder permission as "${username}" this user"
            chown -R ${username}: /home/${username}/BetterArch
            $READ "[+] Enter the Hostname: " nameofmachine
            $ECHO ${nameofmachine} > /etc/hostname && $ECHO "==> Hostname Added !"
        EOF
    	$ECHO "[!] Exiting ! $0" && $SLEEP
        exit
    else
    	$ECHO "[!] Exiting ! $0" && $SLEEP
        exit
    fi
else
    $ECHO "${RED}==> You are already a user proceed with aur installs${NC}"
fi

