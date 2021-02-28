#!/usr/bin/env sh
cd /opt/algo
  # shellcheck source=/dev/null
  . .venv/bin/activate

wget -O /opt/algo/rw-playbook.yml https://raw.githubusercontent.com/rw-martin/algo-setup/main/rw-playbook.yml
ansible-playbook rw-playbook.yml -v
