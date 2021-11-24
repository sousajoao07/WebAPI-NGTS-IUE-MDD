FROM php:8.0-fpm-alpine

USER root

RUN apk --no-cache add \
  sudo            \
  nano            \
  bash            \
  nginx           \
  supervisor      \
  && rm -rf /var/cache/apk/* /tmp/* \
  && mkdir -p /etc/supervisor.d

RUN apk --no-cache add \
  icu-dev           \
  libc-dev          \
  zlib-dev          \
  icu-libs          \
  libzip-dev        \
  libpng-dev        \
  freetype-dev      \
  oniguruma-dev     \
  postgresql-dev    \
  openssh-client    \
  libjpeg-turbo-dev \
  postgresql-client \
  && apk add --virtual build-dependencies \
  $PHPIZE_DEPS \
  libtool      \
  curl-dev     \
  libxml2-dev  \
  && docker-php-source extract \
  && docker-php-ext-configure zip \
  && docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ \
  && docker-php-ext-install -j$(nproc) \
  gd        \
  zip       \
  pdo       \
  xml       \
  curl      \
  exif      \
  intl      \
  iconv     \
  pcntl     \
  bcmath    \
  calendar  \
  mbstring  \
  tokenizer \
  pdo_pgsql \
  && docker-php-source delete \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/* /tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- \
  --install-dir=/usr/local/bin --filename=composer

RUN adduser -D -u 1000 php && echo "php ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY ./php/supervisor.conf /etc/supervisor.d/supervisord.ini
COPY ./php/nginx.conf /etc/nginx/http.d/default.conf
COPY ./php/entrypoint.sh /usr/local/bin/entrypoint

RUN chmod 755 /usr/local/bin/entrypoint

RUN mkdir -p /run/nginx/ /var/log/supervisor /run/php/

RUN sed -i "s/processes auto;/processes 1;/g" /etc/nginx/nginx.conf \
  && sed -i "s|= run|= /run/php|g" /usr/local/etc/php-fpm.conf \
  && sed -i "s/;pid =/pid =/g" /usr/local/etc/php-fpm.conf

USER php

WORKDIR /var/www/api

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]
