FROM ghcr.io/siwatinc/nginx-pagespeed-mariadb:latest
RUN apt-get update && apt-get -y install unzip cron
RUN rm -v /initializer/initialize-builtin.sh /initializer/default && echo '* * * * * /usr/bin/php7.4 /config/www/protected/yii queue/run >/dev/null 2>&1' > /var/spool/cron/crontabs/root && echo '* * * * * /usr/bin/php7.4 /config/www/protected/yii cron/run >/dev/null 2>&1' >> /var/spool/cron/crontabs/root && crontab /var/spool/cron/crontabs/root
RUN wget https://www.humhub.com/download/package/humhub-1.9.0.zip && unzip ./humhub-1.9.0.zip && mv -v ./humhub-1.9.0 /web-source && rm -v ./humhub-1.9.0.zip
ADD ./initialize-builtin.sh /initializer/initialize-builtin.sh
ADD ./initializedb.sql /initializer/initializedb.sql
ADD ./default /initializer/default
CMD chmod +x /initializer/initialize-builtin.sh && /initializer/initialize-builtin.sh && service php7.4-fpm start && nginx
