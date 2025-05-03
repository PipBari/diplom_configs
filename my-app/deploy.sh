#!/bin/bash
set -e

echo "Начинается деплой test..."
cd /home/ubuntu/apps/test

if command -v ansible-playbook >/dev/null 2>&1; then
  echo 'Ansible detected'
  shopt -s nullglob
  for f in *.yml *.yaml; do
    if grep -qE '^ *- *hosts:' "$f"; then
      echo "Запуск Ansible playbook: $f"
      ansible-playbook "$f"
    else
      echo "Пропуск $f — не Ansible playbook"
    fi
  done
  shopt -u nullglob
else
  echo 'Ansible не установлен на сервере'
  exit 1
fi

echo "Деплой завершён"
