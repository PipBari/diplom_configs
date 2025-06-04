#!/bin/bash
set -e

echo "Начинается деплой test_app..."
mkdir -p /home/root/apps/test_app
cd /home/root/apps/test_app

echo "GIT_USERNAME: $GIT_USERNAME"
echo "GIT_TOKEN длина: ${#GIT_TOKEN} символов"

if [ ! -d .git ]; then
  echo 'Репозиторий не найден, клонируем...'
  git clone https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/PipBari/diplom_configs .
else
  echo 'Репозиторий уже существует, выполняем сброс и pull'
  git fetch origin
  git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
  git clean -fd
fi

if command -v terraform >/dev/null 2>&1; then
  echo 'Найден Terraform, выполняется инициализация и применение...'
  terraform init
  terraform apply -auto-approve
else
  echo 'Terraform не установлен'
  exit 1
fi

if command -v ansible-playbook >/dev/null 2>&1; then
  echo 'Найден Ansible, выполняется запуск...'
  for f in *.yml *.yaml; do
    [[ -f "$f" ]] || continue
    echo "→ $f"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook "$f" -i localhost, -c local --extra-vars "ansible_become_pass=$ANSIBLE_BECOME_PASS"
  done
else
  echo 'Ansible не установлен'
  exit 1
fi

echo 'Поиск bash-скриптов...'
for sh in *.sh; do
  [[ "$sh" == "deploy.sh" ]] && continue
  echo "→ bash $sh"
  bash "$sh"
done

echo 'Деплой завершён'
