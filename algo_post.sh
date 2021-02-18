#!/usr/bin/env sh

configAlgo()
{
   
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

   # generate new QR codes to match changed conf files
   apt-get install qrencode -y
   qrencode -o /opt/algo/configs/localhost/wireguard/laptop.png < /opt/algo/configs/localhost/wireguard/laptop.conf
   qrencode -o /opt/algo/configs/localhost/wireguard/surface.png < /opt/algo/configs/localhost/wireguard/surface.conf
   qrencode -o /opt/algo/configs/localhost/wireguard/phonea.png < /opt/algo/configs/localhost/wireguard/phonea.conf
   qrencode -o /opt/algo/configs/localhost/wireguard/phoneb.png < /opt/algo/configs/localhost/wireguard/phoneb.conf


   # reset wireguard interface w/ new port number
   wg showconf wg0 > ./rw.conf
   sed -i 's/ListenPort = 51820/ListenPort = '$ranNum'/g' ./rw.conf
   # sync config w/ new portnum and restart wireguard
   wg-quick down wg0 && wg-quick up wg0
   
   ufw allow $ranNum
}

deployShadowsocks()
{
   # install & config shadowsocks
   apt-get install shadowsocks-libev -y

   ip=$(ip address show dev ens3 | awk '/inet / {print $2}'| cut -d/ -f1)
   wget -O /etc/shadowsocks-libev/config.json https://raw.githubusercontent.com/rw-martin/algo-setup/main/config.json
   sed -i "s/REPLACEME/$ip/g" /etc/shadowsocks-libev/config.json 
}

configUFW()
{
   wget -O /lib/systemd/system/ufw.service https://raw.githubusercontent.com/rw-martin/algo-setup/main/ufw.service
   ufw allow 22
   ufw allow 7443
   echo 'y' | ufw enable
}

### BEGIN
# pull down dnscrypt config file
wget -O /etc/dnscrypt-proxy/dnscrypt-proxy.toml https://raw.githubusercontent.com/rw-martin/algo-setup/main/dnscrypt-proxy.toml
cat /etc/dnscrypt-proxy/dnscrypt-proxy.toml.updates >> /etc/dnscrypt-proxy/dnscrypt-proxy.toml

configAlgo
deployShadowsocks
configUFW

## clean-up

# change default DNS listener to dnscrypt listener
sed -i 's/127.0.0.53/127.0.2.1/g' /etc/resolv.conf 

# config apparmor to allow creation of log files
wget -O /etc/apparmor.d/usr.bin.dnscrypt-proxy https://raw.githubusercontent.com/rw-martin/algo-setup/main/usr.bin.dnscrypt-proxy
systemctl reload apparmor.service

service dnscrypt-proxy stop
service dnscrypt-proxy start
