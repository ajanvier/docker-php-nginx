# Forked from TrafeX/docker-php-nginx (https://github.com/TrafeX/docker-php-nginx/)

FROM alpine:3
LABEL Maintainer="Aurélien JANVIER <dev@ajanvier.fr>" \
      Description="Unofficial Docker image for Polr."

# Environment variables
ENV APP_NAME My Polr
ENV APP_PROTOCOL https://
ENV DB_CONNECTION mysql
ENV DB_PORT 3306
ENV DB_DATABASE polr
ENV DB_USERNAME polr
ENV POLR_BASE 62

# Install packages and remove default server definition
RUN apk --no-cache add bash git php7 php7-fpm php7-opcache php7-mysqli php7-json php7-openssl php7-curl \
        php7-zlib php7-xml php-xmlwriter php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
        php7-mbstring php7-gd php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-tokenizer nginx supervisor curl && \
    apk add --update libintl && \
    apk add --virtual build_deps gettext &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    rm /etc/nginx/conf.d/default.conf

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer

# Setup document root
RUN mkdir -p /var/www/html

# Pull Polr
RUN git clone https://github.com/cydrobolt/polr.git /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
    chown -R nobody.nobody /run && \
    chown -R nobody.nobody /var/lib/nginx && \
    chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
# COPY --chown=nobody src/ /var/www/html/

# Copy env file and setup values
COPY --chown=nobody config/.env_polr .env_polr

# Copy admin seeder
COPY --chown=nobody seeders/AdminSeeder.php AdminSeeder_withoutEnv.php

# Install dependencies
RUN composer install --no-dev -o

# Setting logs permissions
RUN mkdir -p storage/logs && \
    touch storage/logs/lumen.log && \
    chmod -R go+w storage

# Copy start.sh script
COPY --chown=nobody start.sh /start.sh
RUN chmod u+x /start.sh

# Copy wait-for-it.sh
COPY --chown=nobody wait-for-it.sh /wait-for-it.sh
RUN chmod u+x /wait-for-it.sh

# Expose the port nginx is reachable on
EXPOSE 8080

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping

# Bootup
ENTRYPOINT /wait-for-it.sh $DB_HOST:$DB_PORT --strict --timeout=120 -- /start.sh
