#!/bin/bash
set -e

echo "Начинается деплой dasdasd..."
cd /home/ubuntu/apps/dasdasd

echo "GIT_USERNAME: $GIT_USERNAME"
echo "GIT_TOKEN длина: ${#GIT_TOKEN} символов"

if [ ! -d .git ]; then
  echo 'Репозиторий не найден, клонируем...'
  git clone https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/PipBari/diplom_configs repo_tmp
  cp -r repo_tmp/* .
  cp -r repo_tmp/.* . || true
  rm -rf repo_tmp
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
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook "$f" -i localhost,
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
