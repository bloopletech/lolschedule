# Notes on deployment

## Install packages required to run project

````bash
# As root
add-apt-repository ppa:brightbox/ruby-ng
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install build-essential git ruby2.4 ruby2.4-dev imagemagick libmagickwand-dev nginx certbot
gem install bundler
````

## User setup & Web root configuration

````bash
# As root
mkhomedir_helper ubuntu
chsh ubuntu -s /bin/bash
useradd -G www-data ubuntu
chown -R ubuntu:www-data /var/www/html
chmod -R g+rwx /var/www/html
chmod g+s /var/www/html
````

## Switch to ubuntu and configure SSH

````bash
su ubuntu
cd ~
mkdir .ssh
chmod 700 .ssh
cd .ssh
touch authorized_keys
chmod 600 authorized_keys
# Edit authorized_keys file to add your SSH public key
cd ~
````

## Bare Git repo setup

````bash
git clone --bare https://github.com/bloopletech/lolschedule.git /home/ubuntu/lolschedule.git
cat <<EOF > /home/ubuntu/lolschedule.git/hooks/post-receive
#!/bin/bash
git --work-tree=/home/ubuntu/lolschedule --git-dir=/home/ubuntu/lolschedule.git checkout -f
cd /home/ubuntu/lolschedule
bundle install --without development test --deployment
EOF
````

## Create lolschedule directory

````bash
mkdir /home/ubuntu/lolschedule
````

## Environment variables

````bash
cat <<EOF > /home/ubuntu/environment
export LOLSCHEDULE_OUTPUT_DIR="/var/www/html"
export ROLLBAR_TOKEN="<rollbar token>"
EOF
````

## Configure Git remote and first push

````bash
# On your local machine, in lolschedule directory
git remote add droplet ssh://ubuntu@<server IP address>/home/ubuntu/lolschedule.git
git push droplet master
````

## Crontab configuration

````bash
# As root
cat <<EOF > /var/spool/cron/crontabs/ubuntu
*/10 * * * * /home/ubuntu/lolschedule/lolschedule
EOF
````

## Nginx config block

````
# As root
cat <<EOF > /etc/nginx/sites-available/default
server {
        listen 80;
        listen [::]:80 ipv6only=on;
        listen 443 default_server ssl;

        ssl_certificate /etc/letsencrypt/live/lol.bloople.net/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/lol.bloople.net/privkey.pem;

        ssl_dhparam /etc/ssl/private/dhparams.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:ECDHE-RSA-AES128-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA128:DHE-RSA-AES128-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA128:ECDHE-RSA-AES128-SHA384:ECDHE-RSA-AES128-SHA128:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA128:DHE-RSA-AES128-SHA128:DHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA384:AES128-GCM-SHA128:AES128-SHA128:AES128-SHA128:AES128-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
        #ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
        ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
        ssl_session_cache shared:SSL:10m;
        ssl_session_tickets off; # Requires nginx >= 1.5.9
        ssl_stapling on; # Requires nginx >= 1.3.7
        ssl_stapling_verify on; # Requires nginx => 1.3.7
        resolver 8.8.4.4 8.8.8.8 valid=300s;
        resolver_timeout 5s;

        root /var/www/html;
        index index.html;
        server_name lol.bloople.net;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
                expires 10m;
        }

        location /icons.png {
                expires 1h;
        }

        access_log off;
}
EOF
````

## Nginx gzip config block

````
gzip on;
gzip_disable "msie6";

gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_buffers 16 8k;
gzip_http_version 1.1;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
````

## SSL config

````bash
# As root
certbot certonly --webroot -w /var/www/html -d lol.bloople.net
````

## Logrotate config

````bash
# As root
cat <<EOF > /etc/logrotate.d/lolschedule
/home/ubuntu/lolschedule.log {
        daily
        missingok
        rotate 14
        compress
        delaycompress
        notifempty
        create 640 ubuntu ubuntu
}
EOF
````
