export USERS=linksys,laptop,phonea,phoneb,surface,himedia
cd /opt/algo
. .venv/bin/activate
wget -O /dev/shm/reset.yml https://raw.githubusercontent.com/rw-martin/algo-setup/main/reset.yml
wget -O /dev/shm/algo.py https://raw.githubusercontent.com/rw-martin/algo-setup/main/algo.py
ansible-playbook /dev/shm/reset.yml 
