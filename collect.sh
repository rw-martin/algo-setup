HOSTNAME=`hostname -s`
filecur=$(date +"if_octets-%Y-%m-%d")
end=`date '+%Y-%m-%d' -d "$end-1 days"`
filenew=if_octets-$end

tail -5 /var/log/collectd/csv/$HOSTNAME/interface-eth0/$filenew >> /var/log/collectd/csv/$HOSTNAME/interface-eth0/$filecur 
