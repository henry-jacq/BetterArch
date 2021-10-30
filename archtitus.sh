#!/bin/bash
    echo "executing "
    bash 0-preinstall.sh
    echo "executing 1-setup.sh"
    arch-chroot /mnt /root/BetterArch/1-setup.sh
    echo "Sourcing install.conf"
    source /mnt/root/BetterArch/install.conf
    echo "executing 2-user.sh"
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/BetterArch/2-user.sh
    echo "executing 3-post-setup.sh"
    arch-chroot /mnt /root/BetterArch/3-post-setup.sh
