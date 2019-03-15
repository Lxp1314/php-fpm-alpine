FROM php:5.6-fpm-alpine
MAINTAINER wuyun

#WORKDIR /data

RUN apk update
# 安装php7-fpm和扩展 soap依赖libxml2 pdo_dblib依赖FreeTDS
RUN apk add libxml2-dev freetds-dev
RUN docker-php-ext-install soap mysqli pdo_dblib pdo_mysql
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# 安装composer
RUN apk add curl
RUN curl -s http://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
# 配置国内composer镜像
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

#安装supervisor
RUN apk add supervisor
RUN mkdir /etc/supervisor.d

#ENTRYPOINT ["docker-php-entrypoint"]

EXPOSE 9000

CMD ["/usr/bin/supervisord"]