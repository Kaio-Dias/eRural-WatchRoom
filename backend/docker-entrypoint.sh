#!/bin/bash
set -e

echo "==> Waiting for PostgreSQL to be ready..."

DB_HOST=${DB_HOST:-db}
DB_NAME=${POSTGRES_DB:-backend_development}
DB_USER=${POSTGRES_USER:-postgres}
DB_PASS=${POSTGRES_PASSWORD:-postgres}

max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
  if nc -z "$DB_HOST" 5432 2>/dev/null; then
    echo "==> PostgreSQL is ready!"
    break
  fi
  
  attempt=$((attempt + 1))
  echo "Attempt $attempt/$max_attempts - waiting for PostgreSQL..."
  sleep 2
done

if [ $attempt -eq $max_attempts ]; then
  echo "ERROR: Could not connect to PostgreSQL after $max_attempts attempts"
  exit 1
fi

echo "==> Ensuring database '$DB_NAME' exists..."
PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" 2>/dev/null | grep -q 1 || {
  echo "==> Creating database '$DB_NAME'..."
  PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME" 2>/dev/null
  echo "==> Database created successfully!"
}

echo "==> Database ready!"
echo "==> NOTE: Run 'docker compose exec web bin/rails db:migrate' to apply migrations"
echo "==> Starting application..."
exec "$@"
