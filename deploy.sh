#!/bin/bash

set -e  # 發生錯誤時停止執行

APP_DIR="${APP_DIR}"  # 請依實際專案路徑修改
DEPLOY_USER="deploy"

# echo "[$(date +'%Y-%m-%d %H:%M:%S')] Start deploying..." >> /home/deploy/deploy.log

# 進入 Laravel 專案資料夾
cd $APP_DIR
cd $APP_DIR
sudo chown -R deploy:deploy .

# 拉最新程式碼
# sudo -u www-data git pull origin main >> /home/deploy/deploy.log 2>&1
git reset --hard
git pull

# 安裝 Composer 套件（使用 www-data 執行）
# sudo -u www-data composer install --no-interaction --prefer-dist --optimize-autoloader >> /home/deploy/deploy.log 2>&
sudo chown -R www-data:www-data .
sudo -n -u www-data composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# 設定權限（重要，確保 Laravel 可寫入）
sudo -n -u www-data chown -R www-data:www-data storage bootstrap/cache
sudo -n -u www-data chmod -R ug+rwx storage bootstrap/cache

# 執行 Laravel 部署指令
sudo -n -u www-data php artisan config:cache
sudo -n -u www-data php artisan route:cache
sudo -n -u www-data php artisan view:cache

# 執行資料庫 migration（需自行確保可安全執行）
sudo -n -u www-data php artisan migrate --force

# 重啟 queue worker（如果有用 Supervisor，可取消註解）
# sudo supervisorctl restart laravel-worker

# echo "[$(date +'%Y-%m-%d %H:%M:%S')] Deploy done." >> /home/deploy/deploy.log