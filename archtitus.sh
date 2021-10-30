#!/bin/bash
    echo "Starting 0-preintall.sh ####"
    bash 0-preinstall.sh
    echo "[+] 0 is finished ! ####"
    sleep 4
    arch-chroot /mnt /root/ArchTitus/1-setup.sh
    sleep 4
    echo "==> sourcing /mnt/root/ArchTitus/install.conf ####"
    source /mnt/root/ArchTitus/install.conf
    echo "[+] Starting 2-user.sh ! ####"
    sleep 4
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchTitus/2-user.sh
    echo "[+] Starting 3-post-setup.sh ! ####"
    sleep 4
    arch-chroot /mnt /root/ArchTitus/3-post-setup.sh
