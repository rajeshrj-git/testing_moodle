# Use the official PHP 8.3 image with Apache
FROM php:8.3-apache

# Install required PHP extensions and clone Moodle
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unzip git curl libzip-dev libjpeg-dev libpng-dev \
        libfreetype6-dev libicu-dev libxml2-dev libpq-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install mysqli zip gd intl soap exif pgsql pdo_pgsql opcache && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git clone git://git.moodle.org/moodle.git && \
    cd moodle && \
    git branch --track MOODLE_404_STABLE origin/MOODLE_404_STABLE && \
    git checkout MOODLE_404_STABLE && \
    cp -rf ./* /var/www/html/

# PHP settings
RUN echo "max_input_vars=5000" >> /usr/local/etc/php/conf.d/moodle.ini && \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/opcache.ini

# Moodledata directory
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www && chmod -R 755 /var/www

WORKDIR /var/www/html
EXPOSE 80
