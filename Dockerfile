FROM php:5.6-apache

RUN docker-php-ext-install mysqli pdo_mysql
RUN a2enmod rewrite

RUN apt-get update \
&& apt-get install -y \
libz-dev libmemcached-dev libmemcached11 libmemcachedutil2 build-essential libzip-dev zip \
&& pecl install memcached-2.2.0 \
&& echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini \
&& apt-get remove -y build-essential libmemcached-dev libz-dev \
&& apt-get autoremove -y \
&& apt-get clean \
&& rm -rf /tmp/pear

RUN docker-php-ext-configure zip --with-libzip \
&& docker-php-ext-install zip

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html \
    && ls -al /var/www/html

RUN docker-php-ext-enable opcache

# no anda esto, darle permiso localmente para que funcione.
#RUN chmod -R 777 /var/www/html/appserver/protected/runtime
#RUN chmod -R 777 /var/www/html/appserver/protected/data
#RUN echo "max_execution_time = 300" >> /usr/local/etc/php/php.ini
#WORKDIR /var/www/html

COPY . .

#COPY vh.conf /etc/apache2/sites-available/000-default.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80
