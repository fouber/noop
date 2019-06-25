#!/bash/bin

apt update
apt install -y dante-server
cp /etc/danted.conf /etc/danted.conf.bak
echo > /etc/danted.conf
echo 'logoutput: /root/.pm2/logs/dante.log' >> /etc/danted.conf
echo 'internal: eth0 port = 1080' >> /etc/danted.conf
echo 'external: eth0' >> /etc/danted.conf
echo 'method: username none' >> /etc/danted.conf
echo '' >> /etc/danted.conf
echo 'user.privileged: proxy' >> /etc/danted.conf
echo 'user.notprivileged: nobody' >> /etc/danted.conf
echo 'user.libwrap: nobody' >> /etc/danted.conf
echo '' >> /etc/danted.conf
echo 'client pass {' >> /etc/danted.conf
echo '    from: 0.0.0.0/0 port 1-65535 to: 0.0.0.0/0' >> /etc/danted.conf
echo '    log: connect disconnect' >> /etc/danted.conf
echo '}' >> /etc/danted.conf
echo '' >> /etc/danted.conf
echo 'pass {' >> /etc/danted.conf
echo '    from: 0.0.0.0/0 to: 0.0.0.0/0' >> /etc/danted.conf
echo '    protocol: tcp udp' >> /etc/danted.conf
echo '    log: connect disconnect' >> /etc/danted.conf
echo '}' >> /etc/danted.conf
echo '' >> /etc/danted.confx
pm2 stop all
service danted restart
