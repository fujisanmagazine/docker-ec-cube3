FROM php:7.3-apache

MAINTAINER Antonio Kamiya (kamiya@fujisan.co.jp)

ENV ECCUBE_PATH="/var/www/ec-cube"
ARG ECCUBE_DBTYPE="sqlite3"

# envs used inside ec-cube/eccube_install.sh
ENV ADMIN_MAIL="admin@example.com"
ENV SHOP_NAME="EC-CUBE SHOP"
ENV ROOT_URLPATH="/ec-cube/html"
ENV ADMIN_ROUTE="admin"
ENV USER_DATA_ROUTE="user_data"
ENV TEMPLATE_CODE="default"
ENV FORCE_SSL=0

ENV DB_SERVER="127.0.0.1"
ENV DBNAME="cube3_dev"
ENV DBUSER="cube3_dev_user"
ENV DBPASS="password"

ENV MAIL_BACKEND="smtp"
ENV MAIL_HOST="localhost"
ENV MAIL_PORT="25"
ENV MAIL_USER=""
ENV MAIL_PASS=""

# setup dependencies
# added fix for bug in slim image
# https://github.com/debuerreotype/debuerreotype/issues/10
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done \
        && apt-get update && apt-get install --no-install-recommends -y \
            git vim curl wget sudo libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libmcrypt-dev libxml2-dev libpq-dev libpq5 postgresql-client libzip4 libzip-dev sqlite3 \
        && docker-php-ext-configure \
            gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install \
            mbstring zip gd xml pdo pdo_pgsql soap \
        && rm -r /var/lib/apt/lists/*

RUN ls -lt ${PHP_INI_DIR}/conf.d/
COPY config/php.ini ${PHP_INI_DIR}/
COPY config/exec_env.sh /var/www/

## copy EC-CUBE3
COPY ec-cube ${ECCUBE_PATH}

## Edit EC-CUBE3 Configs
RUN sed -i -e '29r /var/www/exec_env.sh' \
           ${ECCUBE_PATH}/eccube_install.sh \
        && chmod +x ${ECCUBE_PATH}/eccube_install.sh \
        && cd ${ECCUBE_PATH} && ./eccube_install.sh ${ECCUBE_DBTYPE} \
        && chown -R www-data:www-data ${ECCUBE_PATH} \
        && ls -lt ${ECCUBE_PATH}/

## Edit apache2 Configs
RUN sed -i -e "s|/var/www/html|${ECCUBE_PATH}/html|g" /etc/apache2/sites-available/000-default.conf

## Entry point
WORKDIR ${ECCUBE_PATH}
EXPOSE 80
CMD apache2-foreground

