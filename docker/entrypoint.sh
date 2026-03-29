#!/bin/sh
set -e
if [ -n "$BRAND_PACKAGE" ]; then
  BRAND_URL="https://cdn.jsdelivr.net/npm/${BRAND_PACKAGE}/brand.json"
  echo "Fetching brand.json from ${BRAND_URL}"
  wget -q -O /app/client/public/brand.json "$BRAND_URL" || echo "WARN: Failed to fetch brand.json, using default"
fi
exec "$@"
