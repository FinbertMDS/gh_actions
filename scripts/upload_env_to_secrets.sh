#!/bin/bash

REPO="FinbertMDS/gh_actions"  # Repo GitHub

ENV_FILE=".env"
echo "🔐 Đang upload secrets từ $ENV_FILE..."

while IFS='=' read -r key value || [[ -n "$key" ]]; do
  if [[ -n "$key" && ! "$key" =~ ^# ]]; then
    echo "⬆️  Setting secret: $key"
    
    tmpfile=$(mktemp 2>/dev/null || echo "./tmp_secret.txt")
    echo -n "$value" > "$tmpfile"

    gh secret set "$key" --repo "$REPO" --body "$(cat "$tmpfile")"
    rm -f "$tmpfile"
  fi
done < "$ENV_FILE"