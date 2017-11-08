#!/usr/bin/env bash

add-apt-repository ppa:brightbox/ruby-ng
apt-get update

install nginx
apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
ln -s /vagrant/project/frontEnd /var/www
ln -s /vagrant/provision/site.conf /etc/nginx/sites-enabled
nginx -s reload

apt-get install -y ruby2.2
apt-get install -y ruby2.2-dev
rm /usr/bin/ruby
ln -s /usr/bin/ruby2.2 /usr/bin/ruby

apt-get install -y g++
gem install thin
gem install faye-websocket
gem install listen
gem install pdf-reader

cd /vagrant/project/backend
thin -p 8080 start -d

echo "DONE"