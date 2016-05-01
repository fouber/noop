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
read -p "pppoe username: " PPPOE_USERNAME < /dev/tty
read -p "pppoe password: " PPPOE_PASSWORD < /dev/tty
CONF="/tmp/.pppoe-cfg.txt"
echo "${PPPOE_USERNAME}"  > ${CONF}
echo "eth0"              >> ${CONF}
echo "no"                >> ${CONF}
echo "223.5.5.5"         >> ${CONF}
echo "223.6.6.6"         >> ${CONF}
echo "${PPPOE_PASSWORD}" >> ${CONF}
echo "${PPPOE_PASSWORD}" >> ${CONF}
echo "0"                 >> ${CONF}
echo "y"                 >> ${CONF}
/tmp/${RP_PPPOE_DIR}/go < ${CONF}
apt-get -y purge --auto-remove make g++
apt-get clean

# pppoe-init
chmod 777 $(fetch pppoe-init /usr/sbin)

# phantomjs
apt-get -y install libfontconfig
wget -qO /usr/sbin/phantomjs http://7xrde2.com1.z0.glb.clouddn.com/phantomjs
chmod 777 /usr/sbin/phantomjs
phantomjs -v

# download node
function get_node(){
    NODE_DIR=$1
    COUNT=$2
    echo "[D] Download... nodejs, count: ${COUNT}."
    if [ ${COUNT} -lt 0 ]; then
        return 0
    else
        NODE_XZ=${NODE_DIR}.tar.xz
        [ -f "${NODE_XZ}" ] && rm -rf ${NODE_XZ}
        wget -O ${NODE_XZ} https://nodejs.org/dist/v4.4.3/${NODE_XZ}
        if [ -f "${NODE_XZ}" ]; then
            xz -d ${NODE_XZ} 2>/dev/null
            NODE_TAR=${NODE_DIR}.tar
            if [ -f "${NODE_TAR}" ]; then
                echo "[D] Download nodejs success, uncompressing..."
                tar xvf ${NODE_TAR} 2>/dev/null
                return 1
            fi
        fi
    fi
    echo "[E] Download nodejs fail, try again."
    TIME=`expr ${COUNT} - 1`
    get_node ${NODE_DIR} ${TIME}
    return $?
}

if [ -z `node -v 2>/dev/null` ] || [ -z `npm -v 2>/dev/null` ]; then
    echo "[D] Unsupport nodejs."
    NODE_DIR=node-v4.4.3-linux-x86
    rm -rf ${NODE_DIR}*
    get_node ${NODE_DIR} 3
    if [ $? -eq 0 ]; then
        echo "[E] Unable download nodejs."
        rm -rf ${NODE_DIR}*
        exit 1
    fi
    echo "[D] Copy files.."
    cp -fr ./bin/* /usr/local/bin/
    cp -r ${NODE_DIR}/* /usr/local/
    rm -rf ${NODE_DIR}*
    node -v
fi

# git
read -p "github username: " GITHUB_USERNAME < /dev/tty
read -p "github password: " GITHUB_PASSWORD < /dev/tty
echo "machine github.com"  > ~/.netrc
echo "login ${GITHUB_USERNAME}" >> ~/.netrc
echo "password ${GITHUB_PASSWORD}" >> ~/.netrc

# FBI
FBI_WARNI_PATH=$(fetch FBI /usr/sbin)
chmod 777 ${FBI_WARNI_PATH}
echo "bash ${FBI_WARNI_PATH}" >> ~/.bashrc
# read -p "repo user: " REPO_USER < /dev/tty
# read -p "repo name: " REPO_NAME < /dev/tty
# echo "cd /tmp" >> ~/.bashrc
# echo "git clone https://github.com/${REPO_USER}/${REPO_NAME}.git" >> ~/.bashrc
# echo "cd ${REPO_NAME}" >> ~/.bashrc
# echo "sh run.sh" >> ~/.bashrc
