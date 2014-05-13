#!/usr/bin/env bash

echo ">>> Installing ElasticHQ"

nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

cd /usr/share/
sudo curl --silent -L https://github.com/royrusso/elasticsearch-HQ/tarball/master | sudo tar -xz
sudo mv *elasticsearch-HQ*/ elastichq/
cd ~

# Set and enable configuration for Apache
if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    cat << EOF | sudo tee -a /etc/apache2/conf-available/elastichq.conf
Alias /elastichq /usr/share/elastichq

<Directory /usr/share/elastichq>

    DirectoryIndex index.html
    AllowOverride None

    order deny,allow
    deny from all
    allow from all

</Directory>
EOF
    sudo a2enconf elastichq

    # Reload Apache to load in configuration
    sudo service apache2 reload
fi

# Set and enable configuration for Nginx
if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    sudo ngxdis vagrant
    sudo sed -i '$ d' /etc/nginx/sites-available/vagrant
sudo tee -a /etc/nginx/sites-available/vagrant > /dev/null <<'EOF'

    location /elastichq {
       root /usr/share/;
       index index.html;
       location ~ ^/elastichq/(.+\.php)$ {
           try_files $uri =404;
           root /usr/share/;
           fastcgi_pass unix:/var/run/php5-fpm.sock;
           fastcgi_index index.php;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include /etc/nginx/fastcgi_params;
       }
       location ~* ^/elastichq/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
           root /usr/share/;
       }
    }

    location /ElasticHQ {
       rewrite ^/* /elastichq last;
    }
}
EOF
    sudo ngxen vagrant

    # Reload Nginx to load in configuration
    sudo service nginx reload
fi
