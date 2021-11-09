#!/usr/bin/env bash

#-------------------------------------------------------------------------
# ______      _   _             ___           _
# | ___ \    | | | |           / _ \         | |
# | |_/ / ___| |_| |_ ___ _ __/ /_\ \_ __ ___| |__
# | ___ \/ _ \ __| __/ _ \ '__|  _  | '__/ __| '_ \
# | |_/ /  __/ |_| ||  __/ |  | | | | | | (__| | | |
# \____/ \___|\__|\__\___|_|  \_| |_/_|  \___|_| |_| v1.6
#
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


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

$ECHO "==> Setting up mirrors for optimal download"

iso=$(curl -4 ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib terminus-font
setfont ter-v22b
sed -i 's/^#Para/Para/' /etc/pacman.conf
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup && $ECHO "==> Creating a mirrorlist backup"

$ECHO """
-------------------------------------------------------------------------
______      _   _             ___           _
| ___ \    | | | |           / _ \         | |
| |_/ / ___| |_| |_ ___ _ __/ /_\ \_ __ ___| |__
| ___ \/ _ \ __| __/ _ \ '__|  _  | '__/ __| '_ \ v1.6
| |_/ /  __/ |_| ||  __/ |  | | | | | | (__| | | |
\____/ \___|\__|\__\___|_|  \_| |_/_|  \___|_| |_|
-------------------------------------------------------------------------
 Setting up $iso mirrors for faster downloads
-------------------------------------------------------------------------
"""
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

$ECHO "\n==> Installing Prerequisites...\n$HR"
$SLEEP
pacman -S --noconfirm gptfdisk btrfs-progs
$ECHO """
-------------------------------------------------
------ select your disk to format ---------------
-------------------------------------------------
"""
$ECHO "${ORANGE}$(lsblk)${NC}"
$READ "==> Please enter disk to work on (Example: /dev/sda): " DISK
export DISK
$ECHO "${RED}[!] THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK${NC}"
$READ "[?] Are you sure you want to continue (Y/N): " formatdisk
case $formatdisk in

    y|Y|yes|Yes|YES)

    $ECHO "--------------------------------------"
    $ECHO "\nFormatting disk...\n$HR"
    $ECHO "--------------------------------------"

    # disk prep
    sgdisk -Z ${DISK} # zap all on disk
    #dd if=/dev/zero of=${DISK} bs=1M count=200 conv=fdatasync status=progress
    sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

    # create partitions
    sgdisk -n 1:0:+1000M ${DISK} # partition 1 (UEFI SYS), default start block, 512MB
    sgdisk -n 2:0:0     ${DISK} # partition 2 (Root), default start, remaining

    # set partition types
    sgdisk -t 1:ef00 ${DISK}
    sgdisk -t 2:8300 ${DISK}

    # label partitions
    sgdisk -c 1:"UEFISYS" ${DISK}
    sgdisk -c 2:"ROOT" ${DISK}

    # make filesystems
    $ECHO "==> \nCreating Filesystems...\n$HR"
    if [[ ${DISK} =~ "nvme" ]]; then
        mkfs.vfat -F32 -n "UEFISYS" "${DISK}p1"
        mkfs.btrfs -L "ROOT" "${DISK}p2" -f
        mount -t btrfs "${DISK}p2" /mnt
    else
        mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
        mkfs.btrfs -L "ROOT" "${DISK}2" -f
        mount -t btrfs "${DISK}2" /mnt
    fi

    ls /mnt | xargs btrfs subvolume delete
    btrfs subvolume create /mnt/@
    umount /mnt
    ;;
    *)
    $ECHO "Rebooting in 3 Seconds ..." && sleep 1
    $ECHO "Rebooting in 2 Seconds ..." && sleep 1
    $ECHO "Rebooting in 1 Second ..." && sleep 1
    reboot now
    ;;
esac

# mount target
$ECHO "==> Mounting the Target"
mount -t btrfs -o subvol=@ -L ROOT /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat -L UEFISYS /mnt/boot/

if ! grep -qs '/mnt' /proc/mounts; then
    $ECHO "[-] Drive is not mounted can't continue"
    $ECHO "[+] Rebooting in 3 Seconds ..." && sleep 1
    $ECHO "[+] Rebooting in 2 Seconds ..." && sleep 1
    $ECHO "[+] Rebooting in 1 Second ..." && sleep 1
    reboot now
fi

$ECHO """
------------------------------------------------
--- Arch Installing on (${DISK}) Main Drive  ---
------------------------------------------------
"""
$SLEEP
pacstrap /mnt base base-devel linux-lts linux-lts-headers efibootmgr linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed

$ECHO "==> Generating Fstab file" && $SLEEP
genfstab -U /mnt >> /mnt/etc/fstab

$ECHO "==> Adding Ubuntu keyserver to gpg" && $SLEEP
$ECHO "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf

$ECHO "==> Copying BetterArch to /mnt/root/BetterArch"
cp -R ${SCRIPT_DIR} /mnt/root/BetterArch

$ECHO "==> Copying pacman mirrorlist to /mnt/../"
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

# $ECHO "
# ----------------------------------------
# -- GRUB BIOS Bootloader Install&Check --
# ----------------------------------------"

$ECHO """
--------------------------------------
-- Bootloader Systemd Installation  --
--------------------------------------
# """
#
# if [[ ! -d "/sys/firmware/efi" ]]; then
#     grub-install --boot-directory=/boot ${DISK}
# fi

bootctl install --esp-path=/mnt/boot

[ ! -d "/mnt/boot/loader/entries" ] && mkdir -p /mnt/boot/loader/entries
cat <<EOF > /mnt/boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd  /initramfs-linux.img
options root=LABEL=ROOT rw rootflags=subvol=@ quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=1
EOF

$ECHO "--------------------------------------"
$ECHO "-- Check for low memory systems <8G --"
$ECHO "--------------------------------------"

TOTALMEM=$(cat /proc/meminfo | grep -i 'emmtotal' | grep -o '[[:digit:]]*')

if [[  $TOTALMEM -lt 8000000 ]]; then
    #Put swap into the actual system, not into RAM disk, otherwise there is no point in it, it'll cache RAM into RAM. So, /mnt/ everything.
    mkdir /mnt/opt/swap #make a dir that we can apply NOCOW to to make it btrfs-friendly.
    chattr +C /mnt/opt/swap #apply NOCOW, btrfs needs that.
    dd if=/dev/zero of=/mnt/opt/swap/swapfile bs=1M count=2048 status=progress
    chmod 600 /mnt/opt/swap/swapfile # set permissions.
    chown root /mnt/opt/swap/swapfile
    mkswap /mnt/opt/swap/swapfile
    swapon /mnt/opt/swap/swapfile
    #The line below is written to /mnt/ but doesn't contain /mnt/, since it's just / for the sysytem itself.
    $ECHO "/opt/swap/swapfile    none    swap    sw      0       0" >> /mnt/etc/fstab #Add swap to fstab, so it KEEPS working after installation.
fi
