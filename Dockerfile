FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    wget \
    nano \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    oniguruma-dev \
    postgresql-dev \
    librdkafka-dev \
    openssl-dev \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    && pecl install rdkafka \
    && docker-php-ext-enable rdkafka \
    && docker-php-ext-configure gd --with-jpeg \
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
    sockets \
    && apk del .build-deps

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Clone specific ProcessMaker version
RUN git clone --branch 4.x --depth 1 https://github.com/wecanco/processmaker.git . \
    && composer install --no-dev --optimize-autoloader --ignore-platform-reqs \
    && chown -R www-data:www-data storage bootstrap/cache

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]