#!/bin/sh

set -e

# Wait for database
if [ "$DB_CONNECTION" = "mysql" ]; then
  until mysqladmin ping -h db -u $DB_USERNAME -p$DB_PASSWORD --silent; do
    echo "Waiting for MySQL..."
    sleep 2
  done
else
  until pg_isready -h db -U $DB_USERNAME -d $DB_DATABASE; do
    echo "Waiting for PostgreSQL..."
    sleep 2
  done
fi

# Run migrations and seeds
php artisan migrate --force
php artisan db:seed --force

# Generate key if not set
if [ -z "$APP_KEY" ]; then
  php artisan key:generate --force
fi

# Fix permissions
chown -R www-data:www-data /var/www/html/storage

exec php-fpm