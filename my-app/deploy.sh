#!/bin/bash
set -e

echo "Начинается деплой test..."
cd /apps/test
docker-compose pull
docker-compose up -d
echo "Деплой завершён"
