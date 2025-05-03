#!/bin/bash
set -e

echo "Начинается деплой das..."
cd /home/ubuntu/apps/das

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
  find . -type f \( -name "*.yml" -o -name "*.yaml" \) | while read f; do
    echo "→ Запуск Ansible playbook: $f"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook "$f" -i localhost, -c local || echo "⚠ Ошибка при запуске $f"
  done
else
  echo 'Ansible не установлен на сервере'
  exit 1
fi

echo "Деплой завершён"
