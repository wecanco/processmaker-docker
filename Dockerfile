FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    wget \
    nano \
    zip \
    unzip \
    bash \
    icu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    oniguruma-dev \
    imagemagick \
    imagemagick-dev \
    imap-dev \
    openssl-dev \
    postgresql-dev \
    librdkafka-dev \
    linux-headers \
    autoconf \
    g++ \
    make \
    shadow \
    musl-dev \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    \
    # Install PECL extensions \
    && pecl install imagick redis rdkafka \
    && docker-php-ext-enable imagick redis rdkafka \
    \
    # Configure and install core PHP extensions
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install \
        pdo_mysql \
        pdo_pgsql \
        zip \
        gd \
        mbstring \
        exif \
        pcntl \
        bcmath \
        opcache \
        intl \
        sockets \
    \
    # Clean up
    && apk del .build-deps

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Clone ProcessMaker (adjust repo/branch if needed)
RUN git clone https://github.com/wecanco/processmaker.git . \
    && composer install --no-dev --optimize-autoloader \
    && chown -R www-data:www-data storage bootstrap/cache

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
#CMD ["php-fpm"]
