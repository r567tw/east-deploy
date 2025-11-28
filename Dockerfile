FROM php:8.4-fpm

# 安裝系統套件與 PHP 擴充
RUN apt-get update && apt-get install -y \
	git \
	curl \
	libpng-dev \
	libonig-dev \
	libxml2-dev \
	zip \
	unzip \
	&& docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 安裝 Xdebug
RUN pecl install xdebug \
	&& docker-php-ext-enable xdebug

# 安裝 Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# 設定工作目錄
WORKDIR /var/www/html

# 複製專案檔案
COPY . .

# 權限設定
RUN chown -R www-data:www-data /var/www/html \
	&& chmod -R 755 /var/www/html

# 預設啟動命令
CMD ["php-fpm"]

EXPOSE 9000
