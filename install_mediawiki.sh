sudo apt-get update && sudo apt-get upgrade

sudo apt-get install apache2 mysql-server php php-mysql libapache2-mod-php php-xml php-mbstring

cd /tmp/wget https://releases.wikimedia.org/mediawiki/1.31/mediawiki-1.31.1.tar.gz

tar -xvzf /tmp/mediawiki-*.tar.gz
sudo mkdir /var/lib/mediawiki
sudo mv mediawiki-*/* /var/lib/mediawiki


sudo ln -s /var/lib/mediawiki /var/www/html/mediawiki