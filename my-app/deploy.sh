#!/bin/bash
set -e

echo "Начинается деплой test..."
cd /home/ubuntu/apps/test

if command -v terraform >/dev/null 2>&1; then
  echo '▶️ Terraform detected'
  terraform init
  terraform apply -auto-approve
else
  echo '❌ Terraform не установлен на сервере'
  exit 1
fi

echo "✅ Деплой завершён"
