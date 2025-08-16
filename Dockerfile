FROM php:8.2-fpm-alpine

# Install dependencies
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
    opcache

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy ProcessMaker source
RUN git clone https://github.com/wecanco/processmaker.git . \
    && composer install --no-dev --optimize-autoloader \
    && chown -R www-data:www-data storage bootstrap/cache

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]