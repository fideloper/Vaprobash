#!/usr/bin/env bash

echo "Lets update our packages list, and currently installed packages...\n";
sudo apt-get update;
sudo apt-get -f -y upgrade;
sudo apt-get -f -y dist-upgrade;

echo "Set-up MySQL and phpMyAdmin (for development purposes ONLY).\n"
DBHOST=localhost
DBUSER=root
DBPASSWD=root
echo 'mysql-server mysql-server/root_password password $DBPASSWD' | debconf-set-selections;
echo 'mysql-server mysql-server/root_password_again password $DBPASSWD' | debconf-set-selections;
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections;
echo 'phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD' | debconf-set-selections;
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD' | debconf-set-selections;
echo 'phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD' | debconf-set-selections;
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect none' | debconf-set-selections;
sudo apt-get -f -y install phpmyadmin;

echo "Set-up Apache Vhost file (assuming phpMyAdmin has been installed to /usr/share/phpmyadmin.\n"
if [ -d "/usr/share/phpmyadmin" ]; then
sudo echo '<VirtualHost *:80>
	ServerName $ServerName
	$ServerAlias
	DocumentRoot /usr/share/phpmyadmin
	<Directory /usr/share/phpmyadmin>
	Options FollowSymLinks
	DirectoryIndex index.php
	<IfModule mod_php.c>
		<IfModule mod_mime.c>
			AddType application/x-httpd-php .php
		</IfModule>
		<FilesMatch ".+\.php$">
			SetHandler application/x-httpd-php
		</FilesMatch>
		php_flag magic_quotes_gpc Off
		php_flag track_vars On
		php_flag register_globals Off
		php_admin_flag allow_url_fopen On
		php_value include_path .
		php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
		php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
	</IfModule>
	</Directory>

	# Authorize for setup
	<Directory /usr/share/phpmyadmin/setup>
		<IfModule mod_authz_core.c>
			<IfModule mod_authn_file.c>
				AuthType Basic
				AuthName \"phpMyAdmin Setup\"
				AuthUserFile /etc/phpmyadmin/htpasswd.setup
			</IfModule>
			Require valid-user
		</IfModule>
	</Directory>

	# Disallow web access to directories that don\''t need it
	<Directory /usr/share/phpmyadmin/libraries>
		Require all denied
	</Directory>
	<Directory /usr/share/phpmyadmin/setup/lib>
		Require all denied
	</Directory>
</VirtualHost>' > /etc/apache2/sites-available/phpmyadmin.localhost.conf
sudo a2ensite phpmyadmin.localhost.conf
sudo service apache2 reload
fi
