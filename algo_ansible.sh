#!/usr/bin/env sh
cd /opt/algo
  # shellcheck source=/dev/null
  . .venv/bin/activate

ansible-playbook main.yml
