#!/bin/sh
cd /var/www/html
php console.php users:create --email yvo@muze.nl --password alice123 alice
