# Notes on deployment

## Install packages required to run project

````bash
add-apt-repository ppa:brightbox/ruby-ng
apt-get update
apt-get install build-essential git ruby2.2 ruby2.2-dev imagemagick libmagickwand-dev nginx
gem install bundler
````

## User setup

````bash
useradd ubuntu
````

## Nginx configuration

````bash
usermod -a -G www-data ubuntu
chown ubuntu:www-data html
chmod g+s /var/www/html
chmod -R g+rwx /var/www/html
````

## Switch to ubuntu

````bash
su ubuntu
````

## Bare Git repo setup

````bash
git clone --bare https://github.com/bloopletech/lolschedule.git /home/ubuntu/lolschedule.git
````

Edit `/home/ubuntu/lolschedule.git/hooks/post-receive`:

````bash
#!/bin/bash
git --work-tree=/home/ubuntu/lolschedule --git-dir=/home/ubuntu/lolschedule.git checkout -f
cd /home/ubuntu/lolschedule
bundle install --without development test --deployment
````

## Environment variables

Create `/home/ubuntu/environment` and edit:

````bash
export LOLSCHEDULE_OUTPUT_DIR="/var/www/html"
export ROLLBAR_TOKEN="<rollbar token>"
````

## Create lolschedule directory

````bash
mkdir /home/ubuntu/lolschedule
````

## Crontab configuration

````
*/10 * * * * /home/ubuntu/lolschedule/lolschedule
````


