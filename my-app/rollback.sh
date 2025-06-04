#!/bin/bash
set -e

echo "Начинается откат приложения test_app..."
echo "→ Terraform destroy (если есть)"
if command -v terraform >/dev/null 2>&1; then
  find . -type f -name "*.tf" | while read tf_file; do
    dir=$(dirname "$tf_file")
    (cd "$dir" && terraform destroy -auto-approve || true)
  done
fi

echo "→ Git reset"
git reset --hard HEAD~1 || true
echo "Откат завершён"
