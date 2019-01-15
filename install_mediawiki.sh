#!/bin/bash
cd /tmp
# Install LAMP
sudo apt-get update -y
sudo apt-get install -y apache2 mysql-server php php-mysql libapache2-mod-php php-xml php-mbstring

# mysql_secure_installation and create mediawiki user
export MYSQL_ROOT_PASSWORD="media"
mysql -uroot << 'EOF'
UPDATE mysql.user SET authentication_string=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
DELETE FROM mysql.user WHERE user='root' AND host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE user='';
CREATE DATABASE mediawiki;
CREATE USER 'media'@'localhost' IDENTIFIED BY 'media';
GRANT ALL ON mediawiki.* TO 'media'@'localhost' IDENTIFIED BY 'media' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Mediawiki installation
wget https://releases.wikimedia.org/mediawiki/1.31/mediawiki-1.31.0.tar.gz
tar -xvzf mediawiki-1.31.0.tar.gz
sudo cp -r mediawiki-1.31.0 /var/www/html/mediawiki
sudo chown -R www-data:www-data /var/www/html/mediawiki
sudo chmod -R 777 /var/www/html/mediawiki

# Create Apache virtual host for mediawiki
touch /etc/apache2/sites-available/mediawiki.conf
cat <<EOT >> /etc/apache2/sites-available/mediawiki.conf
<VirtualHost *:80>
ServerAdmin admin@example.com
DocumentRoot /var/www/html/mediawiki/
ServerName example.com
<Directory /var/www/html/mediawiki/>
Options +FollowSymLinks
AllowOverride All
</Directory>
ErrorLog /var/log/apache2/media-error_log
CustomLog /var/log/apache2/media-access_log common
</VirtualHost>
EOT
mv /var/www/html/index.html /var/www/html/index.html_back
sudo a2ensite mediawiki.conf
sudo a2enmod rewrite

# Restart Apache
sudo systemctl restart apache2
