#!/bin/bash

SUDO_CONF="/etc/sudoers"

apt install -y sudo

sed -i "s|^Defaults\tenv_reset$|Defaults\tenv_reset, timestamp_timeout=-1|g" $SUDO_CONF
sed -i "s|^\%sudo\tALL=(ALL:ALL) ALL$|\%sudo\tALL=(ALL) NOPASSWD:ALL|g" $SUDO_CONF

#add all user to sudo
for user_folder in "/home"/*
do
        user=${user_folder:6}
	/sbin/usermod -aG sudo $user
done

