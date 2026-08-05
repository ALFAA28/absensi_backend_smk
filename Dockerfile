FROM php:8.2-fpm

# Install dependensi sistem dan PostgreSQL driver
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    git \
    curl \
    nginx

RUN docker-php-ext-install pdo pdo_pgsql pgsql

# Copy kodingan ke container
WORKDIR /var/www
COPY . /var/www

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Atur hak akses folder storage & cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 8080

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8080