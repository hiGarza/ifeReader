#!/usr/bin/env bash

#install nginx
apt-get update
apt-get -y install nginx

#remove nginx default site
rm /etc/nginx/sites-enabled/default

#copy app files, site nginx config, and reload nginx
ln -s /vagrant/project/frontEnd /var/www
ln -s /vagrant/provision/site.conf /etc/nginx/sites-enabled
nginx -s reload