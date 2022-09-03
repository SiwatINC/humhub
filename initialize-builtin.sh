echo "Starting Container Initialization Script."
if [ -z "$(ls -A /config)" ]; then
   echo "Initializing . . ."
   mkdir -p -v /config/cache
   mkdir -p -v /config/cache/pagespeed_cache
   mkdir -p -v /config/keys
   mkdir -p -v /config/log/nginx
   mkdir -p -v /config/log/pagespeed
   mkdir -p -v /config/log/php
   mkdir -p -v /config/nginx/site-confs
   mkdir -p -v /config/php
   mkdir -p -v /config/www
   mkdir -p -v /config/keys
   cp -rv /var/lib/mysql /config/database
   mkdir -p /var/cache/nginx | :
   cp /initializer/nginx.conf /config/nginx/nginx.conf
   cp /initializer/fastcgi_params /config/nginx/fastcgi_params
   cp /initializer/mime.types /config/nginx/mime.types
   cp /initializer/default /config/nginx/site-confs/default
   cp -rv /web-source/* /config/www/
   chmod +x /config/www/protected/yii
   chmod 777 -R /config
   service mysql start
   cat /initializer/initializedb.sql | mysql
   cron &
   crontab /var/spool/cron/crontabs/root
   echo "; Add any php.ini entry here to overwrite any php.ini configuration" > /config/php/php-overwrite.ini
   echo "Please replace yourdomain.com with your domain in /config/nginx/site-confs/default to enable pagespeed."
else
   echo "Already Initiated, Starting NGINX PageSpeed and PHP7.4"
   mkdir -p /var/cache/nginx | :
   chmod 777 -R /config
   service mysql start
   echo "If you haven't yet, please replace yourdomain.com with your domain in /config/nginx/site-confs/default to enable pagespeed."
   cat /config/php/php-overwrite.ini >> /etc/php/7.3/fpm/php.ini
   cron &
   crontab /var/spool/cron/crontabs/root
fi

service php7.4-fpm start
nginx
exit 0