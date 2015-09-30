#!/bin/bash

echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list
aptitude update && aptitude upgrade
aptitude install -y apache2\
                    docker.io\
                    apache2\
                    mongodb
a2enmod proxy proxy_http
service apache2 restart
scp vhost_front_wernicke.conf $USER@163.5.245.187:"/etc/apache2/sites-available/"
ssh $USER@163.5.245.187:"a2ensite vhost_front_wernicke && service apache2 relaod"
