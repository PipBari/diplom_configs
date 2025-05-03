#!/bin/bash
set -e

echo "Начинается деплой kavo..."
cd /home/ubuntu/apps/kavo

if [ ! -d .git ]; then
  echo 'Репозиторий не найден, клонируем...'
  git clone https://github.com/PipBari/diplom_configs.git .
  git checkout master
else
  echo 'Репозиторий уже существует, пропускаем клонирование'
fi

echo 'Текущий коммит:'
git log -1 --oneline || true

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
