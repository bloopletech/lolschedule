# Notes on deployment

## User setup

````bash
useradd ubuntu
su ubuntu
````

## Install packages required to run project

````bash
sudo add-apt-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install build-essential git ruby2.2 ruby2.2-dev imagemagick libmagickwand-dev nginx
sudp gem install bundler
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
bundle install --without development test
````

## Environment variables

Create `/home/ubuntu/environment` and edit:

````bash
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

## Nginx configuration

````bash
sudo usermod -a -G www-data ubuntu
sudo chown ubuntu:www-data html
sudo chmod g+s /var/www/html
sudo chmod -R g+rwx /var/www/html
````
