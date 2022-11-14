#!/bin/sh
cd /var/www/html
php console.php database:install
php console.php index:rebuild
php console.php preferences:set auth_api_tokens y
php console.php users:password admin secret
php console.php profile:apply timesheets-profile /profile
cp _htaccess .htaccess
chown www-data:www-data temp
php console.php installer:lock
