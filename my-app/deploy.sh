#!/bin/bash
set -e

echo "Начинается деплой dasd..."
mkdir -p /home/ubuntu/apps/dasd
cd /home/ubuntu/apps/dasd

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

if command -v terraform >/dev/null 2>&1; then
  echo 'Terraform detected'
  find . -type f -name "*.tf" | while read tf_file; do
    dir=$(dirname "$tf_file")
    echo "→ Terraform apply в $dir"
    (cd "$dir" && terraform init && terraform apply -auto-approve)
  done
else
  echo 'Terraform не установлен на сервере'
fi

if command -v ansible-playbook >/dev/null 2>&1; then
  echo 'Ansible detected'
  sb.append("  find . -type f \\( -name \\\"*.yml\\\" -o -name \\\"*.yaml\\\" \\) | while read f; do\n");
    if [[ "$f" == *.github/workflows/* ]]; then
      echo "Пропуск служебного файла: $f"
      continue
    fi
    echo "→ Запуск Ansible playbook: $f"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook "$f" -i localhost, -c local --ask-become-pass || echo "⚠ Ошибка при запуске $f"
  done
else
  echo 'Ansible не установлен на сервере'
fi

echo "Деплой завершён"
