#!/bin/bash
set -e

echo "Начинается деплой eeee..."
cd /home/ubuntu/apps/eeee
docker-compose pull
docker-compose up -d
echo "Деплой завершён"
