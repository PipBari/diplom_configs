#!/bin/bash
set -e

echo "Начинается деплой test_app..."
cd /home/root/apps/test_app

echo "GIT_USERNAME: $GIT_USERNAME"
echo "GIT_TOKEN длина: ${#GIT_TOKEN} символов"

if [ ! -d .git ]; then
  echo 'Репозиторий не найден, клонируем...'
  rm -rf .tmp_clone
  git clone https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/PipBari/diplom_configs .tmp_clone
  mv .tmp_clone/.git ./
  cp -r .tmp_clone/* .
  rm -rf .tmp_clone
else
  echo 'Репозиторий уже существует, выполняем git pull'
  git pull
fi

echo 'Текущий коммит:'
git log -1 --oneline || true

if command -v terraform >/dev/null 2>&1; then
  echo 'Terraform detected'
  find . -type f -name "*.tf" | while read tf_file; do
    dir=$(dirname "$tf_file")
    echo "→ Terraform apply в $dir"
    (cd "$dir" && \
      if [ -f terraform.tfstate.lock.info ]; then \
        echo '→ Обнаружен lock-файл Terraform, пробуем снять'; \
        LOCK_ID=$(grep -oP '\"ID\":\\s*\"\\K[^\"]+' terraform.tfstate.lock.info); \
        echo "→ Снятие lock: $LOCK_ID"; \
        terraform force-unlock "$LOCK_ID" || true; \
      fi && \
      terraform init && terraform apply -auto-approve)
  done
else
  echo 'Terraform не установлен на сервере'
  exit 1
fi

if command -v ansible-playbook >/dev/null 2>&1; then
  echo 'Ansible detected'
  find . -type f \( -name "*.yml" -o -name "*.yaml" \) | while read f; do
    if [[ "$f" == *".github/workflows/"* ]]; then
      echo "Пропуск служебного файла: $f"
      continue
    fi
    echo "→ Запуск Ansible playbook: $f"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook "$f" -i localhost, -c local --extra-vars "ansible_become_pass=$ANSIBLE_BECOME_PASS" || echo "Ошибка при запуске $f"
  done
else
  echo 'Ansible не установлен на сервере'
  exit 1
fi

echo 'Поиск и выполнение Bash-скриптов'
find . -type f -name "*.sh" | while read sh_file; do
  if [[ "$sh_file" == *"/deploy.sh" ]]; then
    echo "Пропуск самого deploy.sh"
    continue
  fi
  echo "→ Запуск bash: $sh_file"
  bash "$sh_file" || echo "Ошибка при выполнении $sh_file"
done

echo "Деплой завершён"
