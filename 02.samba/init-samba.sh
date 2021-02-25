#!/bin/bash

SMB_CONF="/etc/samba/smb.conf"
SMB_CONF_ORIGINAL="/etc/samba/smb.conf.orig"

add_user()
{
	USER=$1
	echo [$USER] >> $SMB_CONF
	echo "   comment = $USER" >> $SMB_CONF
	echo "   path = /home/$USER" >> $SMB_CONF
	echo "   writeable = yes" >> $SMB_CONF
	echo "   valid users = $USER" >> $SMB_CONF
	echo "   wide links = yes" >> $SMB_CONF
	echo "" >> $SMB_CONF
}

# install samba
# setup, forbid prompt when apt install
echo "samba-common samba-common/workgroup string WORKGROUP" | debconf-set-selections
echo "samba-common samba-common/dhcp boolean true" | debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true" | debconf-set-selections
apt install -y samba

# modify samba.conf
#backup config file
if [ ! -f $SMB_CONF_ORIGINAL ]; then
	cp $SMB_CONF $SMB_CONF_ORIGINAL
else
	cp $SMB_CONF_ORIGINAL $SMB_CONF
fi

#add a allow insecure wide links = yes in global
sed -i '/^\[global\]/   a allow insecure wide links = yes' $SMB_CONF

for user_folder in "/home"/*
do
	user=${user_folder:6}
	add_user $user
done

#setup password
for user_folder in "/home"/*
do
	user=${user_folder:6}
	#password = username
	PASS=$user
	echo -ne "$PASS\n$PASS\n" | smbpasswd -a -s $user
done

#restart samba
/etc/init.d/smbd restart
