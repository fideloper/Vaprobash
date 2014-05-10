#!/usr/bin/env bash
#
# Todo:
# - Google how to use sed to insert two lines after a specific line
# - Test it!

echo ">>> Installing Devscripts"

sudo apt-get install devscripts

echo ">>> Installing PHP-ZTS version"

sudo add-apt-repository -y ppa:ondrej/php5

sudo apt-get update

sudo apt-get build-dep php5

sudo apt-get install language-pack-de

sudo apt-get source php5

cd php5*

# Edit debian/rules, add these to "debian/rules"
# --enable-debug \
# --enable-maintainer-zts \
# 
# Help me please!

sudo dpkg-buildpackage

sudo dpkg -i

# PHP Error Reporting Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini
sed -i "s/html_errors = .*/html_errors = On/" /etc/php5/fpm/php.ini

# PHP Date Timezone
sed -i "s/;date.timezone =.*/date.timezone = ${2/\//\\/}/" /etc/php5/fpm/php.ini
sed -i "s/;date.timezone =.*/date.timezone = ${2/\//\\/}/" /etc/php5/cli/php.ini

sudo service php5-fpm restart

cd ..
