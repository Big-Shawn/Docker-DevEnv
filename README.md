# Docker-DevEnv
在Docker中构建PHP+Redis+Nginx 集成开发环境，DNMP

1.单体应用版

- 环境版本说明
    - PHP:  8.0, 已安装插件：php8.0-common php8.0-fpm php8.0-bz2 php8.0-curl php8.0-intl php8.0-mysql php8.0-xml php8.      0-mbstring php8.0-cli php8.0-zip php8.0-gd php8.0-dom
    - Nginx:  1.21.6 
    - redis:  7.0
    - Linux:  Ubuntu 22.04 LTS

- 占用空间
    - Image: 426.83 MB

- 使用方法

    >1. 镜像构建
    >
    >   ```shell
    >   cd SingleApp
    >   docker build -t imageName:tag . // 注意这里有个点，标识当前的构建目录
    >   ```
    >
    >2.  首次使用请勿挂载数据卷，直接建立容器和映射端口
    >
    >   `docker run --name containerName -d imageName:tag -p 81:80`
    >
    >3.  复制容器中的默认配置文件至宿主机当前data目录
    >
    >   `docker cp containerName:/data data `
    >
    >4.  重启建立容器并挂载宿主机目录
    >
    >   `docker run --name containerName2 -d imageName:tag -p 80:80 /data:/path/to/local/data  `
    >
    >5.  配置nginx，php-fpm 
    >
    >6. 设置完成

- 默认配置文件目录说明

    ```shell
    │  
    ├─logs  #日志存放
    │  ├─nginx
    │  ├─php-fpm
    │  └─redis
    ├─redis 
    └─setting #应用配置存放
        ├─nginx
        │  └─conf
        │          fastcgi.conf
        │          fastcgi.conf.default
        │          fastcgi_params
        │          fastcgi_params.default
        │          koi-utf
        │          koi-win
        │          mime.types
        │          mime.types.default
        │          nginx.conf
        │          nginx.conf.default
        │          scgi_params
        │          scgi_params.default
        │          uwsgi_params
        │          uwsgi_params.default
        │          win-utf
        │          
        ├─php
        │  ├─cli
        │  │  │  php.ini
        │  │  │  
        │  │  └─conf.d
        │  ├─fpm
        │  │  │  php-fpm.conf
        │  │  │  php.ini
        │  │  │  
        │  │  ├─conf.d
        │  │  └─pool.d
        │  │          www.conf
        │  │          
        │  └─mods-available
        │          bz2.ini
        │          calendar.ini
        │          ctype.ini
        │          curl.ini
        │          dom.ini
        │          exif.ini
        │          ffi.ini
        │          fileinfo.ini
        │          ftp.ini
        │          gd.ini
        │          gettext.ini
        │          iconv.ini
        │          intl.ini
        │          mbstring.ini
        │          mysqli.ini
        │          mysqlnd.ini
        │          opcache.ini
        │          pdo.ini
        │          pdo_mysql.ini
        │          phar.ini
        │          posix.ini
        │          readline.ini
        │          shmop.ini
        │          simplexml.ini
        │          sockets.ini
        │          sysvmsg.ini
        │          sysvsem.ini
        │          sysvshm.ini
        │          tokenizer.ini
        │          xml.ini
        │          xmlreader.ini
        │          xmlwriter.ini
        │          xsl.ini
        │          zip.ini
        │          
        ├─redis # redis 配置存放
        │      redis.conf
        │      
        └─start # 容器启动脚本
                authority.sh
                nginx.sh
                redis.sh
                start.sh
    ```

- DockerHub镜像地址

    因为网络问题而无法手动构建的同学，可以直接使用Dockerhub上已经构建好的镜像

    ` docker pull shawn2docker/php-nginx-redis:latest`

2.容器网络版
