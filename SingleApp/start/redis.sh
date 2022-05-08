#!/bin/sh
if [ ! -d "/data/logs/redis" ]; then
	mkdir -p /data/logs/redis
fi

if [ ! -d "/data/redis" ]; then
	mkdir -p /data/redis
fi


# 检查用户组
ug=$(ls -l /data/logs/redis | awk '{print $3":"$4}')
if [ "$ug" != "root:root" ]; then
	chown -R root:root /data/logs/redis
fi

ug=$(ls -l /data/redis | awk '{print $3":"$4}')
if [ "$ug" != "root:root" ]; then
	chown -R root:root /data/redis
fi
sed -i 's/daemonize no/daemonize yes/g' /data/setting/redis/redis.conf >> /data/setting/redis/redis.conf

/usr/local/bin/redis-server /data/setting/redis/redis.conf