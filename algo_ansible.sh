#!/usr/bin/env sh

export ANSIBLE_LOG_PATH=~/var/log/ansible.log

cd /opt/algo
  # shellcheck source=/dev/null
  . .venv/bin/activate

wget -O /opt/algo/rw-playbook.yml https://raw.githubusercontent.com/rw-martin/algo-setup/main/rw-playbook.yml
ansible-playbook rw-playbook.yml --vault-password-file=/dev/shm/info
