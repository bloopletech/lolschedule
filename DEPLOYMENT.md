# Notes on deployment

## Install packages required to run project

````bash
# As root
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install build-essential pkg-config git nginx certbot
````

## User setup & Web root configuration

````bash
# As root
useradd -G www-data lolschedule
mkhomedir_helper lolschedule
chsh lolschedule -s /bin/bash
chown -R lolschedule:www-data /var/www/html
chmod -R g+rwx /var/www/html
chmod g+s /var/www/html
rm /var/www/html/index.nginx-debian.html
````

## Install brew and packages

````bash
# As root
usermod -a -G sudo lolschedule
su lolschedule
cd ~
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install ruby@3.3
brew install imagemagick
exit
deluser lolschedule sudo
````

## Switch to ubuntu and configure SSH

````bash
su lolschedule
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
git clone --bare https://github.com/bloopletech/lolschedule.git /home/lolschedule/lolschedule.git
cat <<EOF > /home/lolschedule/lolschedule.git/hooks/post-receive
#!/bin/bash
git --work-tree=/home/lolschedule/lolschedule --git-dir=/home/lolschedule/lolschedule.git checkout -f
cd /home/lolschedule/lolschedule
. /home/lolschedule/environment
export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/lib/pkgconfig:$PKG_CONFIG_PATH"
bundle install
EOF
chmod +x /home/lolschedule/lolschedule.git/hooks/post-receive
````

## Create lolschedule directory

````bash
mkdir /home/lolschedule/lolschedule
cd /home/lolschedule/lolschedule
bundle config set deployment true
bundle config set without 'development test guard'
````

## Environment variables

````bash
cat <<EOF > /home/lolschedule/environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="/home/linuxbrew/.linuxbrew/lib/ruby/gems/3.3.0/bin:$PATH"

export LOLSCHEDULE_ENV="production"
export LOLSCHEDULE_OUTPUT_DIR="/var/www/html"
EOF
````

## Configure Git remote and first push

````bash
# On your local machine, in lolschedule directory
git remote add droplet ssh://lolschedule@<server IP address>/home/lolschedule/lolschedule.git
git commit --allow-empty -m "Bump"
git push droplet master
````

## Crontab configuration

````bash
# As root
cat <<EOF > /var/spool/cron/crontabs/lolschedule
*/10 * * * * /home/lolschedule/lolschedule/lolschedule
EOF

chown lolschedule:lolschedule /var/spool/cron/crontabs/lolschedule
service cron restart
````

## Nginx gzip config block

````
gzip on;
gzip_static on;
gzip_disable "msie6";

gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_buffers 16 8k;
gzip_http_version 1.1;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
````

## Nginx server config block

````
# As root
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen         80;
    listen [::]:80 ipv6only=on;
    return 301 https://\$host\$request_uri;
}

server {
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
                try_files \$uri \$uri/ =404;
                expires 10m;
        }

        location /logos.png {
                expires 1h;
        }

        access_log off;
}
EOF

service nginx restart
````

## SSL config

````bash
# As root
openssl dhparam -dsaparam -out /etc/ssl/private/dhparams.pem 4096
service nginx stop
certbot certonly --standalone -d lol.bloople.net
service nginx start
````

## Logrotate config

````bash
# As root
cat <<EOF > /etc/logrotate.d/lolschedule
/home/lolschedule/lolschedule.log {
        daily
        missingok
        rotate 14
        compress
        delaycompress
        notifempty
        create 640 lolschedule lolschedule
}
EOF
````
