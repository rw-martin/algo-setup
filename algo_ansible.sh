#!/usr/bin/env sh

export ANSIBLE_LOG_PATH=~/var/log/ansible.log
export USERS=linksys,laptop,phonea,phoneb,surface,himedia

cd /opt/algo
  # shellcheck source=/dev/null
  . .venv/bin/activate

wget -O /dev/shm/rw-playbook.yml https://raw.githubusercontent.com/rw-martin/algo-setup/main/rw-playbook.yml
ansible-playbook /dev/shm/rw-playbook.yml --vault-password-file=/dev/shm/info >> /dev/shm/ansible.log

sleep 5s
