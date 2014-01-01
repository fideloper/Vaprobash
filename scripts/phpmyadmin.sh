#!/usr/bin/env bash

echo ">>> Installing phpMyAdmin"

MYSQL_ROOT_PASS=root

sudo add-apt-repository -y ppa:nijel/phpmyadmin
sudo apt-get update

echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/setup-password password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/database-type select mysql" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/mysql/app-pass password" | debconf-set-selections
echo "dbconfig-common dbconfig-common/password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
sudo apt-get install -y phpmyadmin
