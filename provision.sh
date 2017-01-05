#!/bin/bash
set -e

# install dependency package
yum install -y vim wget net-tools unzip

# install epel package
yum install -y epel-release

# install nginx
yum install -y nginx

# install php-fpm
rpm -Uvh /vagrant/remi-release-7.rpm
yum install -y php56-php-fpm php56-php-mysqlnd php56-php-mbstring

# install mariadb
yum install -y mariadb-server

# setting nginx
rm -f /etc/nginx/nginx.conf
ln -s /vagrant/nginx.conf /etc/nginx/nginx.conf
chown nginx.nginx /etc/nginx/nginx.conf
ln -s /vagrant/wordpress.conf /etc/nginx/conf.d/wordpress.conf
chown nginx.nginx /etc/nginx/conf.d/wordpress.conf

# setting php-fpm
sed -i -e 's/user = apache/user = nginx/g' /opt/remi/php56/root/etc/php-fpm.d/www.conf
sed -i -e 's/group = apache/group = nginx/g' /opt/remi/php56/root/etc/php-fpm.d/www.conf

# start daemon 
systemctl start mariadb
systemctl start nginx
systemctl start php56-php-fpm

# install wp-cli
cd
yum install -y php56
ln -s /bin/php56 /bin/php
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# install wordpress
mkdir -p /usr/share/nginx/wordpress
chown nginx.nginx /usr/share/nginx/wordpress

sudo -u nginx /usr/local/bin/wp core download \
  --locale=ja \
  --path=/usr/share/nginx/wordpress

sudo -u nginx /usr/local/bin/wp core config \
  --dbname='wordpress' \
  --dbuser='root' \
  --dbpass='' \
  --dbhost='localhost' \
  --path=/usr/share/nginx/wordpress

sudo -u nginx /usr/local/bin/wp db create \
  --path=/usr/share/nginx/wordpress

sudo -u nginx /usr/local/bin/wp core install \
  --url='192.168.33.60' \
  --title='larning-wordpress' \
  --admin_name='root' \
  --admin_password='root' \
  --admin_email='root@larning.wordpress.example' \
  --path=/usr/share/nginx/wordpress

