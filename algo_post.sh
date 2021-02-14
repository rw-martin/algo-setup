#!/usr/bin/env sh

# pull down dnscrypt config file
wget -O /etc/dnscrypt-proxy/dnscrypt-proxy.toml https://raw.githubusercontent.com/rw-martin/algo-setup/main/dnscrypt-proxy.toml

# use random port for WireGuard
cd /opt/algo
ranNum=$(shuf -i 58000-58900 -n 1)
echo $ranNum
sed -i 's/wireguard_port: 51820/wireguard_port: '$ranNum'/g' config.cfg

sed -i 's/ListenPort = 51820/ListenPort = '$ranNum'/g' /etc/wireguard/wg0.conf

sed -i '/- desktop/a\  \- phonea' config.cfg
sed -i '/- desktop/a\  \- phoneb' config.cfg
sed -i '/- desktop/a\  \- linksys' config.cfg
sed -i '/- desktop/a\  \- surface' config.cfg

sed -i "s/51820/$ranNum/g" /opt/algo/configs/localhost/wireguard/laptop.conf
sed -i "s/51820/$ranNum/g" /opt/algo/configs/localhost/wireguard/surface.conf
sed -i "s/51820/$ranNum/g" /opt/algo/configs/localhost/wireguard/phonea.conf
sed -i "s/51820/$ranNum/g" /opt/algo/configs/localhost/wireguard/phoneb.conf

# reset wireguard interface w/ new port number
wg showconf wg0 > ./rw.conf
sed -i 's/ListenPort = 51820/ListenPort = '$ranNum'/g' ./rw.conf

ufw allow $ranNum
ufw allow 22
echo 'y' | ufw enable

# change default DNS listener to dnscrypt listener
sed -i 's/127.0.0.53/127.0.2.1/g' /etc/resolv.conf 

# sync config w/ new portnum and restart wireguard
#cat ./rw.conf
#wg setconf wg0 ./rw.conf
#sleep 5s

wg-quick down wg0 && wg-quick up wg0


# install & config shadowsocks
apt-get install shadowsocks-libev -y

ufw allow 7443

ip=$(ip address show dev ens3 | awk '/inet / {print $2}'| cut -d/ -f1)
echo "
{
   "server":[\""$ip"\"],
   "mode":"tcp_and_udp",
   "server_port":7443,
   "password":"beans",
   "timeout":120,
   "method":"chacha20-ietf",
   "fast_open":true,
   "nameserver":"8.8.8.8"
}
" > /etc/shadowsocks-libev/config.json


# config apparmor to allow creation of log files
wget -O /etc/apparmor.d/usr.bin.dnscrypt-proxy https://raw.githubusercontent.com/rw-martin/algo-setup/main/usr.bin.dnscrypt-proxy

systemctl reload apparmor.service

service dnscrypt-proxy stop
service dnscrypt-proxy start
