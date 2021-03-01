#!/bin/bash

SCRIPTPATH=$(dirname "$0")
run_as_user()
{
	user=$1
	cmd=$2
	/bin/su -c "$cmd" - $user
}

setup_vim()
{
	user_folder=$1
	user=${user_folder:6}
	cp $SCRIPTPATH/data/vimrc $user_folder/.vimrc
	cp $SCRIPTPATH/data/vimrc.local $user_folder/.vimrc.local
	cp $SCRIPTPATH/data/vimrc.local.bundles $user_folder/.vimrc.local.bundles
	chown $user:$user $user_folder/.vimrc $user_folder/.vimrc.local $user_folder/.vimrc.local.bundles
	run_as_user $user "git clone https://github.com/lifepillar/vim-solarized8.git ~/.vim/pack/themes/opt/solarized8"
	run_as_user $user "sh -c '/bin/echo -e \“\n\” | vim +PlugInstall +qall'"
	run_as_user $user "cd ~/.vim/plugged/YouCompleteMe/ && ./install.py --clangd-completer"
	run_as_user $user "cd ~/.vim/plugged/color_coded/ && mkdir -p build && cd build && cmake .. -DDOWNLOAD_CLANG=0 && make && make install && make clean"
}

vim_support_python3=`vim --version|grep \+python3`
vim_support_lua=`vim --version|grep \+lua`
if [ ! -z "$vim_support_python3" ] && [ ! -z "$vim_support_lua" ] ; then
	echo "already support"
else
	apt install -y dpkg-dev libncurses-dev libpython3-dev liblua5.3-dev lua5.3 python3
	#apt source vim
	git clone https://github.com/vim/vim.git

	vim_src_folder=`find -type d -maxdepth 1 -name "vim*"`
	cd $vim_src_folder
	make distclean
	./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu --enable-luainterp=yes --enable-cscope --prefix=/usr/local --enable-gui=no --with-tlib=ncurses
	make install
	cd ..
	rm -rf "vim*"
fi

apt install -y git curl cmake zlib1g-dev libclang-dev llvm
apt install -y python clang #for color_coded
for user_folder in "/home"/*
do
	setup_vim $user_folder
done
