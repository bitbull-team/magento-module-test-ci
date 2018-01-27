#!/usr/bin/env bash
###################################################################################
# Spin up a Magento temporary instance with the module under test installed on int
###################################################################################

set -e

apt-get update
apt-get -y install jq

# Modify entrypoint to start Apache in background, then start it now
sed -i 's|-D FOREGROUND| |g' /entrypoint

export WEB_DOCUMENT_ROOT=/var/www/html/web

/bin/sh -c /entrypoint

# Replace in the composer.json the module path
sed -i "s|{{MODULE_DIR}}|$MODULE_DIR|g" composer.json

# Replace in the composer.json the module name
MODULE_NAME=`jq -r '.name' $MODULE_DIR/composer.json`

sed -i "s|{{MODULE_COMPOSER_NAME}}|$MODULE_NAME|g" composer.json

# Install needed dependencies for a base Magento installation, plus the module under test
# @todo make the composer.json configurable for the specific module
composer install --no-dev --no-interaction

# Import fixtures database
# @todo make it configurable for the specific module
mysql -h 127.0.0.1 -u root -proot magento < db.sql

# Download and extract fixtures media
# @todo

# Copy the local.xml
mv local.xml web/app/etc/local.xml

# Copy the htaccess to use during this test phase
mv .htaccess web/.htaccess

# Move all the content of build directory in the Apache docroot
rm -Rf /var/www/html/*

mv web vendor /var/www/html/

