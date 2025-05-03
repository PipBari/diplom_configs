#!/bin/bash
set -e

echo "Начинается деплой oeoe..."
cd /apps/oeoe
docker-compose pull
docker-compose up -d
echo "Деплой завершён"
