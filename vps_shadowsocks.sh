#! /bin/sh

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
        strings /dev/urandom | head -n 10 | tr -d '[:blank:]\n\r'; echo
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
        yum install python-setuptools && easy_install pip
elif $(has_command apt-get); then
        apt-get install python-pip
fi

# install shadowsocks server
pip install shadowsocks

# starting shadowsocks server
PASSWORD=$(generate_password) 
ssserver -s 0.0.0.0 -p 1984 -k $PASSWORD -m aes-256-cfb –workers 10 -d start
echo $PASSWORD > ~/shadowsocks.password
