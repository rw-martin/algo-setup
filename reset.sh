export USERS=linksys,laptop,phonea,phoneb,surface,himedia
cd /opt/algo
. .venv/bin/activate
wget -O /dev/shm/reset.yml https://raw.githubusercontent.com/rw-martin/algo-setup/main/reset.yml
ansible-playbook ./reset.yml 