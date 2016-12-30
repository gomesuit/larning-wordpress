#!/bin/bash
set -e

# install dependency package
yum install -y vim wget net-tools unzip

# install epel package
yum install -y epel-release

# install nginx
yum install -y nginx

# install php-fpm
yum install -y php-fpm php-mysql

# install mariadb
yum install -y mariadb-server

# setting nginx
rm -f /etc/nginx/nginx.conf
ln -s /vagrant/nginx.conf /etc/nginx/nginx.conf
chown nginx.nginx /etc/nginx/nginx.conf
ln -s /vagrant/wordpress.conf /etc/nginx/conf.d/wordpress.conf
chown nginx.nginx /etc/nginx/conf.d/wordpress.conf

# setting php-fpm
sed -i -e 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf

# setting wordpress
cd /usr/share/nginx
wget https://ja.wordpress.org/wordpress-4.6.1-ja.zip
unzip wordpress-4.6.1-ja.zip
rm wordpress-4.6.1-ja.zip
chown nginx.nginx -R wordpress
ln -s /vagrant/wp-config.php /usr/share/nginx/wordpress/wp-config.php

# start daemon 
systemctl start mariadb
systemctl start nginx
systemctl start php-fpm

# initialize database
mysql -u root -e "create database wordpress;"

