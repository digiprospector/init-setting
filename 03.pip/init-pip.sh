#!/bin/bash

PIP_CONF="/etc/pip.conf"

apt install -y python3-pip

#create a global pip config file
#use local source
echo [global] > $PIP_CONF
echo index-url = https://mirrors.aliyun.com/pypi/simple/ >> $PIP_CONF

#update pip
pip3 install --upgrade pip

