FROM phpdockerio/php73-fpm:latest

ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /application

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

COPY "memory-limit-php.ini" "/etc/php/7.3/cli/conf.d/memory-limit-php.ini"

# Install selected extensions and other stuff
RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    # utils
    git \
    ant \
    # chrome
    chromium-chromedriver \
    # php ext
    php7.3-bcmath \
    php7.3-intl \
    php7.3-gd \
    php7.3-gmp \
    php7.3-pgsql \
    php7.3-phpdbg \
    php-xdebug \
 && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install nodejs -yq

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install yarn -yq

RUN curl -SL https://github.com/theseer/phpdox/releases/download/0.11.2/phpdox-0.11.2.phar --silent -o phpdox-0.11.2.phar \
    && mv phpdox-0.11.2.phar /usr/local/bin/phpdox \
    && chmod +x /usr/local/bin/phpdox

RUN curl -SL https://phar.phpunit.de/phpunit-7.phar --silent -o phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# Dependency check
RUN curl -L https://dl.bintray.com/jeremy-long/owasp/dependency-check-5.3.0-release.zip --output dependency-check-5.3.0-release.zip \
    && unzip dependency-check-5.3.0-release.zip \
    && mv dependency-check /usr/share/
ENV PATH="/usr/share/dependency-check/bin:${PATH}"
RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz | tar xz \
    && mv mysql-connector-java-8.0.19 /var/lib/mysql/

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN composer global require friendsoftwig/twigcs