#!/bin/bash

SCRIPTPATH=$(dirname "$0")
GIT_USERNAME="digiprospector"
GIT_MAIL="digiprospector@protonmail.com"

run_as_user()
{
	user=$1
	cmd=$2
	/bin/su -c "$cmd" - $user
}

setup_git()
{
	user_folder=$1
	user=${user_folder:6}
	run_as_user $user "git config --global user.name \"$GIT_USERNAME\""
	run_as_user $user "git config --global user.email \"$GIT_MAIL\""

	run_as_user $user "mkdir -p ${user_folder}/.ssh"
	run_as_user $user "echo Host github.com > $user_folder/.ssh/config"
	run_as_user $user "echo \"  IdentityFile ~/.ssh/github_rsa\" >> $user_folder/.ssh/config"
	cp $SCRIPTPATH/data/github_rsa $user_folder/.ssh/github_rsa
	chown $user:$user $user_folder/.ssh/github_rsa
    chmod 400 $user_folder/.ssh/github_rsa
}

apt -y install git

for user_folder in "/home"/*
do
	setup_git $user_folder
done
