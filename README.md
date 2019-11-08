# Custom Symfony 4 Docker image

This is the image we use at Kinoba to start developing quickly on a Symfony 4 project.

## What's inside?

- phpdockerio/php73-fpm:latest
- php-ext:
    - php7.3-pgsql
    - php-xdebug
    - php7.3-intl
    - php7.3-gd
    - php7.3-phpdbg
- nodejs 8.x
- yarn
- composer
- ant
- phpdox ([https://github.com/theseer/phpdox](https://github.com/theseer/phpdox))
- phpunit-7

## Build

`docker build -t kinoba/docker-symfony4-postgres .`
