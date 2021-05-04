wget -O /root/newlist.out https://phishing.army/download/phishing_army_blocklist_extended.txt
cat /etc/dnscrypt-proxy/blacklist.txt /root/newlist.out > /root/updatedlist.out
dos2unix /root/updatedlist.out
sort /root/updatedlist.out | uniq > /etc/dnscrypt-proxy/blacklist.txt
systemctl restart dnscrypt-proxy
