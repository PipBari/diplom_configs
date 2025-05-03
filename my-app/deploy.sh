#!/bin/bash
set -e

echo "Начинается деплой test..."
cd /home/ubuntu/apps/test

echo '▶️ Terraform detected'
terraform init
terraform apply -auto-approve
echo "✅ Деплой завершён"
