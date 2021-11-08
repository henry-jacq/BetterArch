#!/bin/bash

username=$(cat credentials.conf | awk -F "=" '{print $2}')

bash preinstall.sh
arch-chroot /mnt /root/BetterArch/setup.sh
source /mnt/root/BetterArch/credentials.conf
arch-chroot /mnt /usr/bin/runuser -u ${username} -- /home/${username}/BetterArch/user.sh
arch-chroot /mnt /root/BetterArch/post-setup.sh
