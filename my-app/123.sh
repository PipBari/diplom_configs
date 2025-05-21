#!/bin/bash

echo "Подготовка окружения..."

TARGET_DIR="./output"

if [ ! -d "$TARGET_DIR" ]; then
  mkdir "$TARGET_DIR"
  echo "Папка $TARGET_DIR создана"
else
  echo "Папка $TARGET_DIR уже существует"
fi

echo "Скрипт выполнен $(date)" > "$TARGET_DIR/result.txt"
echo "Файл result.txt создан в $TARGET_DIR"

echo "Содержимое файла:"
cat "$TARGET_DIR/result.txt"

echo "Готово"
