#!/bin/sh

cd /var/www/html
if [ ! -f ".env" ]; then
    POLR_GENERATED_AT=`date +"%B %d, %Y"`
    export POLR_GENERATED_AT

    APP_KEY=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    export APP_KEY

    envsubst < ".env_polr" > ".env"

    rm -f .env_polr
    php artisan migrate:install
    php artisan migrate --force
    composer dump-autoload
    php artisan geoip:update
fi

if [ ! -f "database/seeds/AdminSeeder.php" ]; then
    envsubst < "AdminSeeder_withoutEnv.php" > "database/seeds/AdminSeeder.php"

    rm -f AdminSeeder_withoutEnv.php
    composer dump-autoload
    php artisan db:seed --class=AdminSeeder --force
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
