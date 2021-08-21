#!/usr/bin/env sh

export ANSIBLE_LOG_PATH=~/var/log/ansible.log
export USERS=linksys,laptop,phonea,phoneb,surface,himedia

hostname > /dev/shm/info

cd /opt/algo
  # shellcheck source=/dev/null
  . .venv/bin/activate

wget -O /dev/shm/rw-playbook.yml https://raw.githubusercontent.com/rw-martin/algo-setup/main/rw-playbook.yml
ansible-playbook /dev/shm/rw-playbook.yml --vault-password-file=/dev/shm/info

sleep 5s
