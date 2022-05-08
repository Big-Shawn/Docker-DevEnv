FROM ubuntu:latest as base

# 软件安装过程中遇到了时区问题。。。

ENV TIME_ZONE=Asia/Shanghai

#挂载匿名卷宗
VOLUME /data 

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y tzdata \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*
#安装php  使用apt 方式安装不能定义设置文件的安装目录
#TODO 设置PHP配置文件所在目录

RUN set -x; apt-get update \
    && apt-get install -y software-properties-common \
    # 安装ppa 软件仓库
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    # 安装php8.0 及需要的插件
    && apt-get install -y php8.0-common php8.0-fpm php8.0-bz2 php8.0-curl php8.0-intl php8.0-mysql php8.0-xml php8.0-mbstring php8.0-cli php8.0-zip php8.0-gd php8.0-dom \
    && mkdir -p /data/setting/php \
    && cp -r /etc/php/8.0/* /data/setting/php/ \
    # && ln -s /etc/php /data/setting/php \
    && apt-get remove -y software-properties-common \
    # auto 自动清除为了安装软件而安装的依赖和配置
    # apt 下有诸多的缓存清理方式需要视情况进行使用
    # apt-get clean /  apt-get remove / apt-get autoremove / apt-get purge 等
    && apt-get autoremove -y \
    #清除软件缓存
    && apt-get clean \
    && rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*

#安装Composer
WORKDIR /root/temp/

RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"  \
    && php composer-setup.php \
    # 设置全局命令
    && mv composer.phar /usr/local/bin/composer \
    # 设置国内镜像
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    # 更新一下
    && composer selfupdate \
    # 删除安装文件
    && rm -rf ./*

# 设置PHP 配置文件目录 php-fpm

#安装Redis
#TODO:  需要设置Redis的配置文件，以及设置Redis 自动启动等参数配置
# 编译完成之后是不是可以直接复制二进制文件到文件夹中然后直接进行运行，这样无效的文件是不是就又变少了呢？
ENV Dependence="g++ make wget"
# 系统之中存在tar 这个软件，所以在重新安装的时候就会出现问题

#ubuntu 中没有gcc-c++ 这个包，只能装g++ 这个才来对Redis 进行编译安装了
RUN set -x; apt-get update \
    # && apt-get install -y aptitude \
    && apt-get install -y ${Dependence} \
    #下载最新Redis安装包
    && wget http://download.redis.io/releases/redis-7.0.0.tar.gz \
    && tar xzf redis-7.0.0.tar.gz\
    && cd redis-7.0.0 \
    && make \
    # 删除编译包，并移动默认配置文件未知
    #还要设置后台自启动
    #将编译后的二进制可执行文件移动至全局命令中
    && mkdir -p /data/setting/redis/ \
    && cp redis.conf /data/setting/redis/redis.conf \
    #设置全局命令
    && cd src \
    && cp redis-cli redis-benchmark redis-check-aof redis-check-rdb redis-server redis-trib.rb redis-sentinel /usr/local/bin \
    #清理安装包
    && rm -rf /root/temp/redis-* \
    # && rm -rf /root/temp/* \
    #清除安装时所依赖的软件包
    && apt-get remove -y ${Dependence} \
    && apt-get autoremove -y \
    #清除软件缓存
    && apt-get clean \
    && rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*

# 开放 Redis 端口
EXPOSE 6379

#启动Redis

#安装 Nginx
#FROM nginx:alpine as nginx 
#设置Nginx 配置文件目录
ENV NginxDepend="gcc make wget libpcre3-dev zlib1g-dev openssl libssl-dev"
RUN set -x; apt-get update \
    && apt-get install -y ${NginxDepend} \
    && wget https://nginx.org/download/nginx-1.21.6.tar.gz \
    && tar zxvf nginx-1.21.6.tar.gz \
    #添加nginx运行账户
    && useradd nginx -s /sbin/nologin -M \
    && useradd www -s /sbin/nologin -M \
    && cd nginx-1.21.6 \
    && ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx \
    && make && make install \
    # && echo "daemon on;" >>/usr/local/nginx/conf/nginx.conf \
    && mkdir -p /data/setting/nginx \
    && cp -r /usr/local/nginx/sbin/* /usr/local/bin/ \
    && cp -r /usr/local/nginx/conf /data/setting/nginx/ \
    && mkdir -p /data/setting/start/ \
    && apt-get install -y vim \
    # && ln -s /usr/local/nginx/conf /data/setting/nginx/ \
    # && cp nginx /usr/local/bin \
    && apt-get remove -y ${NginxDepend} \
    # auto 自动清除为了安装软件而安装的依赖和配置
    # apt 下有诸多的缓存清理方式需要视情况进行使用
    # apt-get clean /  apt-get remove / apt-get autoremove / apt-get purge 等
    && apt-get autoremove -y \
    #清除软件缓存
    && apt-get clean \
    && rm -rf /root/*  \
    && rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*


#开放HTTP端口
EXPOSE 443 80 

WORKDIR /data

#创建文件夹并安装常用工具
COPY start/* /data/setting/start

RUN  chmod +x /data/setting/start/start.sh 

CMD ["sh", "/data/setting/start/start.sh"]


#FROM nginx:latest as nginx

# 2022年5月5日 
#问题: 不能使用 FROM nginx:alpine 来进行多阶段构建，但是还是目前来说应该是安装好了php 和 redis 看下使用效果怎么样了
# 2022年5月6日
# 已完成： PHP + Redis + Nginx 已经安装完毕
# 待处理： 
#配置文件的设置， 如何将配置文件集合在一起能够进行统一管理
#容器启动后不能实时的显示信息，至少要显示一下nginx 的访问信息比较好
#好像还要做supervisor 来防止进程挂掉了  然后就是supervisor怎么用不太
# 2022年5月7日
# 昨天还觉得如果要做配置文件集中一定得需要编译安装才行，现在想想好像也不用
# 更新一下思路
# 1. 将安装好的软件一起复制到同一位置
# 2.设置启动脚本




#  最后要设置命令，进行使用，这里如果直接使用默认的redis文件进行配置的话能不能达到预期的效果？

# 1. 设置 php-fpm 的配置文件路径
# 2. 设置 redis 的配置文件
# 3. 设置 nginx 的默认配置文件  以及日志存放位置

