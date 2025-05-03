#!/bin/bash
set -e

echo "Начинается деплой test..."
cd /home/ubuntu/apps/test

if [ ! -f docker-compose.yml ]; then
  echo "❌ docker-compose.yml не найден — пропуск деплоя"
  exit 0
fi

docker-compose pull
docker-compose up -d
echo "Деплой завершён"
