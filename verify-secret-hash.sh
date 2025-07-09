#!/bin/bash

HASH_FILE=".secret-hash-check.txt"

echo "📄 Đang kiểm tra hash secrets từ $HASH_FILE..."

fail=0

while IFS='=' read -r key expected_hash || [[ -n "$key" ]]; do
  [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue

  # Lấy giá trị biến môi trường chứa secret (ví dụ: $MY_SECRET)
  actual_value="${!key}"

  if [[ -z "$actual_value" ]]; then
    echo "⚠️  $key không được set trong env"
    fail=1
    continue
  fi

  # Tính hash và so sánh
  actual_hash=$(echo -n "$actual_value" | shasum -a 256 | awk '{print $1}')

  if [[ "$actual_hash" == "$expected_hash" ]]; then
    echo "✅ $key: Trùng khớp"
  else
    echo "❌ $key: KHÔNG khớp"
    echo "   Expected: $expected_hash"
    echo "   Actual  : $actual_hash"
    fail=1
  fi
done < "$HASH_FILE"

if [[ $fail -eq 1 ]]; then
  echo "❌ Có secret không trùng. Dừng workflow."
  exit 1
else
  echo "🎉 Tất cả secrets đều trùng khớp!"
fi
