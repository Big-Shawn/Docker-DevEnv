#!/bin/bash

# 日志目录
if [ ! -d "/data/logs/nginx" ]; then
	mkdir -p /data/logs/nginx
fi

if [ ! -d "/data/logs/php-fpm" ]; then
	mkdir -p /data/logs/php-fpm
fi

if [ ! -d "/run/php" ]; then
	mkdir -p /run/php
fi

# 检查权限
ug=$(ls -l /data/logs/nginx | awk '{print $3":"$4}')
if [ "$ug" != "www:www" ]; then
	chown -R www:www /data/logs/nginx
fi

ug=$(ls -l /data/logs/php-fpm | awk '{print $3":"$4}')
if [ "$ug" != "www:www" ]; then
	chown -R www:www /data/logs/php-fpm
fi

# 启动 PHP-FPM
/usr/sbin/php-fpm8.0 -c /data/setting/php/fpm/php.ini -y /data/setting/php/fpm/php-fpm.conf --daemonize

# 启动 NGINX
/usr/local/bin/nginx -c /data/setting/nginx/conf/nginx.conf -g "daemon off;"