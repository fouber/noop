#!/usr/bin/env bash

# sources
echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse"                  > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse"        >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse"         >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse"        >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse"       >> /etc/apt/sources.list

echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse"             >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse"    >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse"     >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse"    >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse"   >> /etc/apt/sources.list

apt-get update

# timezone
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# dns
echo "nameserver 223.5.5.5"  > /etc/resolv.conf
echo "nameserver 223.6.6.6" >> /etc/resolv.conf

# git
apt-get -y install git

# vim
apt-get -y install vim
rm -rf /usr/bin/vi
ln -s /usr/bin/vim /usr/bin/vi
echo "set nu"            > ~/.vimrc
echo "set cindent"      >> ~/.vimrc
echo "set expandtab"    >> ~/.vimrc
echo "set shiftwidth=4" >> ~/.vimrc
echo "set tabstop=4"    >> ~/.vimrc
echo "set incsearch"    >> ~/.vimrc
echo "set hlsearch"     >> ~/.vimrc

# rp-pppoe
RP_PPPOE_DIR=rp-pppoe-3.12
cd /tmp
apt-get -y install make g++
wget https://www.roaringpenguin.com/files/download/${RP_PPPOE_DIR}.tar.gz
tar zxvf ${RP_PPPOE_DIR}.tar.gz
cd ${RP_PPPOE_DIR}
sed '$d' /tmp/${RP_PPPOE_DIR}/go | sh
rm -rf ${RP_PPPOE_DIR}

# pppoe-init
read -p "PPPOE Username: " USERNAME < /dev/tty
read -p "PPPOE Password: " PASSWORD < /dev/tty
CONF="/tmp/.pppoe-cfg.txt"
echo "${USERNAME}"  > ${CONF}
echo "eth0"        >> ${CONF}
echo "no"          >> ${CONF}
echo "server"      >> ${CONF}
echo "${PASSWORD}" >> ${CONF}
echo "${PASSWORD}" >> ${CONF}
echo "0"           >> ${CONF}
echo "y"           >> ${CONF}
/usr/sbin/pppoe-setup < ${CONF}
rm -rf ${CONF}

# FBI
BRL='\033[41m'
BRR='\033[49m'
CWL='\033[1;37m'
CWR='\033[0m'

printf "${CWL}\n"
printf "                        ${BRL} FBI WARNING ${BRR}\n"
printf "\n"
printf " Federal Law provides severe civil and criminal penalties for \n"
printf " the unauthorized reproduction, distribution, or exhibition of \n"
printf " copyrighted motion pictures (Title 17, United States Code, \n"
printf " Sections 501 and 508). The Federal Bureau of Investigation \n"
printf " investigates allegations of criminal copyright infringement\n"
printf "         (Title 17, United States Code, Section 506).\n"
printf "${CWR}\n"
