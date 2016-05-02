#!/usr/bin/env bash

TEMP=/tmp/.default_route
SERVER=
USERNM=
PASSWD=
VPNAME=test
CMD=$1

function vpn_off(){

    if [ -f "${TEMP}" ]; then
        poff -a 2>&1 1>/dev/null
        route -n | grep eth0 | awk '{print $1,$2,$3}' | while read net gw mask; do
            if [ "${gw}" != "0.0.0.0" ]; then
                route del -net ${net} netmask ${mask}
            fi
        done
        ip route add `cat ${TEMP}`
    fi
}

function vpn_on(){

    vpn_off

    if [ ! -f "${TEMP}" ]; then
        ip route | head -1 > ${TEMP}
    fi

    pptpsetup              \
      --create   ${VPNAME} \
      --server   ${SERVER} \
      --username ${USERNM} \
      --password ${PASSWD} \
      --encrypt            \
      --start

    route del default
    route add default dev ppp0
}

function vpn_help(){
    echo "Usage:"
    echo "  vpn on         start vpn"
    echo "  vpn off        stop vpn"
}

case ${CMD} in
    "on"  ) vpn_on   ;;
    "off" ) vpn_off  ;;
    *     ) vpn_help ;;
esac
