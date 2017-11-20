#!/usr/bin/env bash

PROJECT_LOG_FILE=./freebtc.website.new.localhost.build.log;
echo "" > $PROJECT_LOG_FILE;

echo "Moving into /home/vagrant/code/freebtc.website.new.localhost.\n" >> $PROJECT_LOG_FILE;
cd /home/vagrant/code/freebtc.website.new.localhost >> $PROJECT_LOG_FILE;

echo "Update global Composer first, befire installing/updating packages.\n"
composer self-update >> $PROJECT_LOG_FILE;

echo "Install Composer packages for project.\n" >> $PROJECT_LOG_FILE;
composer install >> $PROJECT_LOG_FILE;

echo "If Composer packages are already installed for project, let's update them.\n" >> $PROJECT_LOG_FILE;
composer update >> $PROJECT_LOG_FILE;

echo "Compile back-end assets.\n" >> $PROJECT_LOG_FILE;
composer dump-autoload --optimize &&
php artisan optimize &&
php artisan clear-compiled &&
php artisan cache:clear &&
php artisan view:clear &&
php artisan laroute:generate && 
php artisan key:generate >> $PROJECT_LOG_FILE;

echo "Run database migrations, and seed with data (errors will be logged).\n" >> $PROJECT_LOG_FILE;
php artisan migrate --seed >> $PROJECT_LOG_FILE;

echo "Install NPM packages for project.\n" >> $PROJECT_LOG_FILE;
npm install --force --save >> $PROJECT_LOG_FILE

echo "Install front-end packages via Bower.\n" >> $PROJECT_LOG_FILE;
bower install --save --force >> $PROJECT_LOG_FILE;

echo "Compile front-end assets.\n" >> $PROJECT_LOG_FILE;
gulp copyfiles &&
gulp &&
gulp minifycss &&
gulp minifyjs >> $PROJECT_LOG_FILE;

echo "Chown storage directory for Apache user:group (www-data:www-data).\n"
chown -R www-data:www-data /home/vagrant/code/freebtc.website.new.localhost/storage

echo "Make storage directory readable/writeable.\n"
chmod -R 755 /home/vagrant/code/freebtc.website.new.localhost/storage

echo "Now create Apache Vhost file and enable site.\n"
sudo vhost -s freebtc.website.new.localhost -d /home/vagrant/code/freebtc.website.new.localhost/public