FROM php:8.1.3-fpm

RUN apt-get update && apt-get install -y \
    default-mysql-client \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    git vim unzip cron \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl

RUN docker-php-ext-install -j$(nproc) opcache bcmath pdo_mysql soap xsl zip sockets

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Create user magento
RUN useradd -m -s /bin/bash magento \
    && usermod -a -G www-data magento

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

ADD ./php-custom.ini $PHP_INI_DIR/conf.d/

# Install mysql 8.0.33 and import magento database

CMD ["php-fpm"]

EXPOSE 9000