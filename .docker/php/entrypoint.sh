#!/usr/bin/env sh

sudo find ./bootstrap/cache ./storage ! -path */\.gitignore -type f -exec chmod 664 {} \; -exec chown php:www-data {} \;
sudo find ./bootstrap/cache ./storage -type d -exec chmod 775 {} \; -exec chown php:www-data {} \;

# Setup composer dependencies
if [ ! -d "vendor" ]; then
    composer install
fi

# Wait until mysql is ready
echo "PostgreSQL isn't available - Waiting for it.."
until pg_isready --host=db --port=5432 --dbname=ngts_iue_dmd --username=root &> /dev/null; do sleep 1; done

# Setup env files and migrations
if [ ! -f ".env" ]; then
    cp -f .env.example .env
    php artisan key:generate
    php artisan migrate:refresh --seed
fi

exec sudo -E "${@}"
