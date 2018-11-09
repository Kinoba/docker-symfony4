FROM phpdockerio/php72-fpm:latest
WORKDIR "/application"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        # utils
        git \
        ant \
        # chrome
        chromium-chromedriver \
        # php ext
        php7.2-intl \
        php7.2-gd \
        php7.2-gmp \
        php7.2-pgsql \
        php7.2-phpdbg \
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

# Install phpunit
RUN composer global require phpunit/phpunit ^7.0 --no-progress --no-scripts --no-interaction
