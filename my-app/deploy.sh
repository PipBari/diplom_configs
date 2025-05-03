#!/bin/bash
set -e

echo "Начинается деплой test..."
cd /home/ubuntu/apps/test

if command -v ansible-playbook >/dev/null 2>&1; then
  echo 'Ansible detected'
  ansible-playbook playbook.yml
else
  echo 'Ansible не установлен на сервере'
  exit 1
fi

echo "Деплой завершён"
