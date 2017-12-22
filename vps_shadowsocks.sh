#!/bin/bash

# usage: curl https://raw.githubusercontent.com/fainted/scripts/master/vps_shadowsocks.sh | bash

# staring a shadowsocks service instance
# for Ubuntu/Debian(apt-get) Centos(yum)
# generate random password stored in ~/shadowsocks.password

function has_process() {
        if [[ $(ps -ef | grep $1 | grep -v grep | wc -l ) > 0 ]]; then
                echo true
                return
        fi
        
        echo false
}

function has_command() {
        if [[ $(command -v $1) != "" ]]; then
                echo true
                return
        fi

        echo false
}

function generate_password() {
        tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -1
}

# exit if shadowsocks server started already
if $(has_process ssserver); then
        echo "shadowsocks server started already"
        exit
fi

# install python-pip
if $(has_command pip); then
        echo "pip already installed"
elif $(has_command yum); then
        yum --assumeyes install python-setuptools && easy_install pip
elif $(has_command apt-get); then
        apt-get -y install python-pip
fi

# install shadowsocks server
pip install shadowsocks

# starting shadowsocks server
PASSWORD=$(generate_password) 
ssserver -d start -s 0.0.0.0 -p 1984 -k $PASSWORD -m aes-256-cfb –workers 10
echo $PASSWORD > ~/shadowsocks.password
