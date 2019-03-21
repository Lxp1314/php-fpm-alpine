FROM php:5.6-fpm-alpine
MAINTAINER wuyun

#WORKDIR /data

#RUN apk update
# 安装php-fpm和扩展 soap依赖libxml2 pdo_dblib依赖FreeTDS gd依赖libjpeg-turbo-dev、libpng-dev和freetype-dev
RUN apk --update add libxml2-dev \
        freetds-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	freetype-dev \
	libmcrypt-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2/freetype --with-jpeg-dir=/usr/include --with-png-dir=/usr/include
RUN docker-php-ext-install soap mysqli pdo_dblib pdo_mysql gd zip iconv
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# 安装composer
RUN apk add curl
RUN curl -s http://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
# 配置国内composer镜像
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

#安装supervisor
RUN apk add supervisor
RUN mkdir /etc/supervisor.d

#iconv函数测试
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

#ENTRYPOINT ["docker-php-entrypoint"]

EXPOSE 9000

CMD ["/usr/bin/supervisord"]
