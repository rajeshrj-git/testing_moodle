# PHP 8.3 image with Apache
FROM php:8.3-apache

# PHP extensions
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unzip \
        git \
        curl \
        libzip-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libicu-dev \
        libxml2-dev \
        libpq-dev \
        libonig-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure\ php extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install \
        mysqli \
        zip \
        gd \
        intl \
        soap \
        exif \
        pgsql \
        pdo_pgsql \
        opcache \
        mbstring

RUN git clone --branch MOODLE_500_STABLE --depth 1 https://github.com/moodle/moodle.git /var/www/html && \
    rm -rf /var/www/html/.git

# PHP settings
RUN { \
    echo 'max_input_vars=5000'; \
    echo 'post_max_size=128M'; \
    echo 'upload_max_filesize=128M'; \
    echo 'memory_limit=256M'; \
    echo 'max_execution_time=300'; \
} > /usr/local/etc/php/conf.d/moodle.ini

# OPcache settings
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.max_accelerated_files=10000'; \
    echo 'opcache.validate_timestamps=1'; \
} > /usr/local/etc/php/conf.d/opcache.ini

# Set permissions
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www && \
    chmod -R 755 /var/www

# Enable Apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html
EXPOSE 80