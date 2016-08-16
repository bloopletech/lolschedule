# Notes on deployment

## Install packages required to run project

````bash
sudo add-apt-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install build-essential git ruby2.2 ruby2.2-dev imagemagick libmagickwand-dev
````

## Bare Git repo setup

````bash
git clone --bare git@github.com:bloopletech/lolschedule.git /home/ubuntu/lolschedule.git
````

Edit `/home/ubuntu/lolschedule.git/hooks/post-receive`:

````bash
#!/bin/bash
git --work-tree=/home/ubuntu/lolschedule --git-dir=/home/ubuntu/lolschedule.git checkout -f
cd /home/ubuntu/lolschedule
bundle install
````

## Environment variables

Create `/home/ubuntu/environment` and edit:

````bash
export ROLLBAR_TOKEN="<rollbar token>"
````

## Crontab configuration

````
*/10 * * * * /home/ubuntu/lolschedule/lolschedule
````
