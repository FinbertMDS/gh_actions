#!/bin/bash

ENV_FILE=".env"
HASH_FILE=".secret-hash-check.txt"

echo "# Secret hash check file" > "$HASH_FILE"

while IFS='=' read -r key value || [[ -n "$key" ]]; do
  if [[ -n "$key" && ! "$key" =~ ^# ]]; then
    hash=$(echo -n "$value" | shasum -a 256 | awk '{print $1}')
    echo "$key=$hash" >> "$HASH_FILE"
    echo "✅ $key => $hash"
  fi
done < "$ENV_FILE"