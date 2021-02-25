#!/bin/bash

ZSH_CONF="~/.oh-my-zsh"
PWD=`pwd`
run_as_user()
{
	user=$1
	cmd=$2
	/bin/su -c "$cmd" - $user
}

setup_oh_my_zsh()
{
	user_folder=$1
	user=${user_folder:6}
	if [ ! -d "${user_folder}/.oh-my-zsh" ] ; then
		run_as_user $user "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
	fi
	run_as_user $user "cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"
	if [ ! -d "${user_folder}/.autojump" ] ; then
		run_as_user $user "cd ${PWD}/autojump && ./install.py"
	fi

	if [ ! -d "${user_folder}/.oh-my-zsh/plugins/zsh-autosuggestions" ] ; then
		run_as_user $user "git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions"
	fi

	if [ ! -d "${user_folder}/.oh-my-zsh/plugins/zsh-syntax-highlighting" ] ; then
		run_as_user $user "git clone git://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/plugins/zsh-syntax-highlighting"
	fi

	#modify theme
	sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"ys\"/g" ${user_folder}/.zshrc
	sed -i "s/^plugins=.*/plugins=(git docker autojump zsh-autosuggestions zsh-syntax-highlighting)/g" ${user_folder}/.zshrc

	echo "[[ -s ${user_folder}/.autojump/etc/profile.d/autojump.sh ]] && source ${user_folder}/.autojump/etc/profile.d/autojump.sh" >> ${user_folder}/.zshrc
	echo bindkey  "^[[1~"   beginning-of-line >> ${user_folder}/.zshrc
	echo bindkey  "^[[4~"   end-of-line >> ${user_folder}/.zshrc
	
}

apt install -y zsh

#install oh-my-zsh
apt install -y git
git clone git://github.com/joelthelion/autojump.git

for user_folder in "/home"/*
do
	setup_oh_my_zsh $user_folder
done

rm -rf autojump
