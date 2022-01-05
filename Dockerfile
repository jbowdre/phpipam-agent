FROM php:7.4.11-alpine3.11

ARG TARGETPLATFORM
RUN echo "TARGETPLATFORM : $TARGETPLATFORM"

ENV PHPIPAM_AGENT_SOURCE https://github.com/phpipam/phpipam-agent

RUN apk add --no-cache --virtual .build-dependencies git \
    \
    && apk add --no-cache \
       apk-cron \
       gmp \
       gmp-dev \
       gettext \
       gettext-dev \
       iputils \
       fping \
       bash \
       tzdata \
     \
# Configure apache and required PHP modules
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install json \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install gettext \
    && docker-php-ext-install gmp \
    && docker-php-ext-install pcntl

COPY php.ini /usr/local/etc/php/
COPY entrypoint.sh /

# Clone phpipam-agent sources
WORKDIR /opt/
RUN git clone ${PHPIPAM_AGENT_SOURCE}.git

WORKDIR /opt/phpipam-agent
# Use system environment variables into config.php
RUN cp config.dist.php config.php && \
    sed -i -e "s/\['key'\] = .*;/\['key'\] = getenv(\"PHPIPAM_AGENT_KEY\");/" \
    -e "s/\['pingpath'\] = .*;/\['pingpath'\] = \"\/usr\/sbin\/fping\";/" \
    -e "s/\['db'\]\['host'\] = \"localhost\"/\['db'\]\['host'\] = getenv(\"MYSQL_ENV_MYSQL_HOST\")/" \
    -e "s/\['db'\]\['user'\] = \"phpipam\"/\['db'\]\['user'\] = getenv(\"MYSQL_ENV_MYSQL_USER\")/" \
    -e "s/\['db'\]\['pass'\] = \"phpipamadmin\"/\['db'\]\['pass'\] = getenv(\"MYSQL_ENV_MYSQL_PASSWORD\")/" \
    -e "s/\['db'\]\['name'\] = \"phpipam\"/\['db'\]\['name'\] = getenv(\"MYSQL_ENV_MYSQL_DATABASE\")/" \
    -e "s/\['db'\]\['port'\] = 3306/\['db'\]\['port'\] = getenv(\"MYSQL_ENV_MYSQL_PORT\")/" \
    config.php \
    \
    && chmod +x /entrypoint.sh \
    \
    && apk del --no-cache --purge .build-dependencies \
    && rm -fr \
        /tmp/*

# Setup crontab
ENV CRONTAB_FILE=/var/spool/cron/crontabs/root

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "sh", "-c", "crond -l 2 -f" ]

