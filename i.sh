#!/usr/bin/env bash

# consts
BASE_URL=https://raw.githubusercontent.com/fouber/noop/master

# base url
fetch(){
    REMOTE=$1
    LOCAL=$2/${REMOTE}
    wget -q ${BASE_URL}/${REMOTE} -O ${LOCAL}
    echo ${LOCAL}
}

# timezone
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# sources
fetch sources.list /etc/apt
apt-get update

# git
apt-get -y install git

# vim
apt-get -y install vim
rm -rf /usr/bin/vi
ln -s /usr/bin/vim /usr/bin/vi
fetch .vimrc ~

# rp-pppoe
RP_PPPOE_DIR=rp-pppoe-3.12
cd /tmp
apt-get -y install make g++
wget -q https://www.roaringpenguin.com/files/download/${RP_PPPOE_DIR}.tar.gz
tar zxvf ${RP_PPPOE_DIR}.tar.gz
cd ${RP_PPPOE_DIR}
sed '$d' /tmp/${RP_PPPOE_DIR}/go | sh
rm -rf ${RP_PPPOE_DIR}
apt-get purge --auto-remove make g++
apt-get clean

# pppoe-init
chmod 777 $(fetch pppoe-init /usr/sbin)

# FBI
FBI_WARNI_PATH=$(fetch FBI /usr/sbin)
chmod 777 ${FBI_WARNI_PATH}
echo "bash ${FBI_WARNI_PATH}" >> ~/.bashrc
