#!/bin/bash

yum install -y vim wget net-tools unzip

yum install -y epel-release

yum install -y nginx php-fpm php-mysql

rm -f /etc/nginx/nginx.conf
ln -s /home/vagrant/sync/nginx.conf /etc/nginx/nginx.conf
chown nginx.nginx /etc/nginx/nginx.conf
ln -s /home/vagrant/sync/wordpress.conf /etc/nginx/conf.d/wordpress.conf
chown nginx.nginx /etc/nginx/conf.d/wordpress.conf

sed -i -e 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i -e 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf

cd /usr/share/nginx
wget https://ja.wordpress.org/wordpress-4.6.1-ja.zip
unzip wordpress-4.6.1-ja.zip
rm wordpress-4.6.1-ja.zip
chown nginx.nginx -R wordpress



yum install -y mariadb-server

