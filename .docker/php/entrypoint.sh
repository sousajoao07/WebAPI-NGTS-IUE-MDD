#!/usr/bin/env sh

sudo find ./bootstrap/cache ./storage ! -path */\.gitignore -type f -exec chmod 664 {} \; -exec chown php:www-data {} \;
sudo find ./bootstrap/cache ./storage -type d -exec chmod 775 {} \; -exec chown php:www-data {} \;

# Setup composer dependencies
if [ ! -d "vendor" ]; then
    cp -f .env.example .env
    composer install
fi

# Wait until mysql is ready
until mysqladmin ping --host=db --port=3306 --user=homestead --password=secret | grep "mysqld is alive" ; do
  >&2 echo "MySQL isn't available - Waiting for it.."
  sleep 1
done

# Run migrations and seeds
php artisan migrate:refresh --seed

exec sudo -E "${@}"
