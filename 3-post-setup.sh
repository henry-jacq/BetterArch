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

$ECHO "\n==> Reached Final setup and configuration"

# ------------------------------------------------------------------------

$ECHO "${GREEN}\n[+] Enabling Login Display Manager${NC}"

sudo systemctl enable sddm.service

$ECHO "${GREEN}\n[+] Setting up SDDM Theme${NC}"

sudo cat <<EOF > /etc/sddm.conf
[Theme]
Current=Nordic
EOF

# ------------------------------------------------------------------------

$ECHO "${GREEN}\n[+] Enabling essential services${NC}"

systemctl enable cups.service && $SLEEP
sudo ntpd -qg && $SLEEP
sudo systemctl enable ntpd.service && $SLEEP
sudo systemctl disable dhcpcd.service && $SLEEP
sudo systemctl stop dhcpcd.service && $SLEEP
sudo systemctl enable NetworkManager.service && $SLEEP
sudo systemctl enable bluetooth && $SLEEP

$ECHO "
###############################################################################
# Cleaning
###############################################################################
"
# Remove no password sudo permissions
$ECHO "${RED}[!] Removing no password permissions${NC}"
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo permissions
$ECHO "${GREEN}[+] Adding sudo permissions to $(users)${NC}"
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Replace in the same state
cd $pwd

$ECHO "
###############################################################################
# Done - Please Eject Install Media and Reboot
###############################################################################
"
