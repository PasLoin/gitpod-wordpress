#!/bin/sh

echo "\n* Running composer ...";
runuser -g www-data -u www-data -- /usr/local/bin/composer install --no-interaction

echo "\n* Build assets ...";
runuser -g www-data -u www-data -- /usr/bin/make assets

if [ "$DB_SERVER" = "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    echo >&2 'error: You requested automatic PrestaShop installation but MySQL server address is not provided '
    echo >&2 '  You need to specify DB_SERVER in order to proceed'
    exit 1
elif [ "$DB_SERVER" != "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
    RET=1
    while [ $RET -ne 0 ]; do
        echo "\n* Checking if $DB_SERVER is available..."
        mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "status" > /dev/null 2>&1
        RET=$?

        if [ $RET -ne 0 ]; then
            echo "\n* Waiting for confirmation of MySQL service startup";
            sleep 5
        fi
    done
        echo "\n* DB server $DB_SERVER is available, let's continue !"
fi

# From now, stop at error
set -e

if [ ! -f ./config/settings.inc.php ]; then
    if [ $PS_INSTALL_AUTO = 1 ]; then

        echo "\n* Installing PrestaShop, this may take a while ...";

        if [ $PS_ERASE_DB = 1 ]; then
            echo "\n* Drop & recreate mysql database...";
            if [ $DB_PASSWD = "" ]; then
                echo "\n* Dropping existing database $DB_NAME..."
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -e "drop database if exists $DB_NAME;"
                echo "\n* Creating database $DB_NAME..."
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER create $DB_NAME --force;
            else
                echo "\n* Dropping existing database $DB_NAME..."
                mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "drop database if exists $DB_NAME;"
                echo "\n* Creating database $DB_NAME..."
                mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force;
            fi
        fi

        if [ "$PS_DOMAIN" = "<to be defined>" ]; then
            export PS_DOMAIN=$(hostname -i)
        fi

        echo "\n* Launching the installer script..."
        runuser -g www-data -u www-data -- php /var/www/html/$PS_FOLDER_INSTALL/index_cli.php \
        --domain="$PS_DOMAIN" --db_server=$DB_SERVER:$DB_PORT --db_name="$DB_NAME" --db_user=$DB_USER \
        --db_password=$DB_PASSWD --prefix="$DB_PREFIX" --firstname="John" --lastname="Doe" \
        --password=$ADMIN_PASSWD --email="$ADMIN_MAIL" --language=$PS_LANGUAGE --country=$PS_COUNTRY \
        --all_languages=$PS_ALL_LANGUAGES --newsletter=0 --send_email=0 --ssl=$PS_ENABLE_SSL

        if [ $? -ne 0 ]; then
            echo 'warning: PrestaShop installation failed.'
        fi
    fi
else
    echo "\n* Pretashop Core already installed...";
fi

if [ $PS_DEMO_MODE -ne 0 ]; then
    echo "\n* Enabling DEMO mode ...";
    sed -ie "s/define('_PS_MODE_DEMO_', false);/define('_PS_MODE_DEMO_',\ true);/g" /var/www/html/config/defines.inc.php
fi

echo "\n* Almost ! Starting web server now\n";

exec apache2-foreground

# WordPress Setup Script
export REPO_NAME=$(basename $GITPOD_REPO_ROOT)

function wp-init-database () {
  # user     = wordpress
  # password = wordpress
  # database = wordpress
  mysql -e "CREATE DATABASE wordpress /*\!40100 DEFAULT CHARACTER SET utf8 */;"
  mysql -e "CREATE USER wordpress@localhost IDENTIFIED BY 'wordpress';"
  mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
}

function wp-setup () {
  FLAG="$HOME/.wordpress-installed"

  # search the flag file
  if [ -f $FLAG ]; then
    echo 'WordPress already installed'
    return 1
  fi
  
  DESTINATION=${GITPOD_REPO_ROOT}/${APACHE_DOCROOT}/wp-content/$1/${REPO_NAME}

  echo 'Please, wait ...'

  # this would cause mv below to match hidden files
  shopt -s dotglob
  
  echo 'Creating MySQL user and database ...'
  wp-init-database 1> /dev/null

  # move the workspace temporarily
  mkdir $HOME/workspace
  mv ${GITPOD_REPO_ROOT}/* $HOME/workspace/

  echo 'Installing WordPress ...'
  # create webserver root and install WordPress there
  mkdir -p ${GITPOD_REPO_ROOT}/${APACHE_DOCROOT}
  mv $HOME/wordpress/* ${GITPOD_REPO_ROOT}/${APACHE_DOCROOT}/

  # put the project files in the correct place
  mkdir $DESTINATION
  mv $HOME/workspace/* $DESTINATION
  
  # create a wp-config.php
  cp $HOME/gitpod-wordpress/conf/wp-config.php ${GITPOD_REPO_ROOT}/${APACHE_DOCROOT}/wp-config.php

  # Setup WordPress database
  cd ${GITPOD_REPO_ROOT}/${APACHE_DOCROOT}/
  wp core install \
    --url="$(gp url 8080 | sed -e s/https:\\/\\/// | sed -e s/\\///)" \
    --title="WordPress" \
    --admin_user="admin" \
    --admin_password="password" \
    --admin_email="admin@gitpod.test"

  cd $DESTINATION
  # install project dependencies
  if [ -f composer.json ]; then
    echo 'Installing Composer packages ...'
    composer update 2> /dev/null
  fi
  if [ -f package.json ]; then
    echo 'Installing NPM packages ...'
    npm i 2> /dev/null
  fi

  if [ -f $DESTINATION/.init.sh ]; then
    echo 'Running your .init.sh ...'
    /bin/sh $DESTINATION/.init.sh
  fi
  
  shopt -u dotglob
  touch $FLAG
  
  echo 'Done!'
}

function wp-setup-theme () {
  wp-setup "themes"
}

function wp-setup-plugin () {
  wp-setup "plugins"
}

export -f wp-setup-theme
export -f wp-setup-plugin

# Helpers
function browse-url () {
  ENDPOINT=${1:-""}
  PORT=${2:-"8080"}
  URL=$(gp url $PORT | sed -e s/https:\\/\\/// | sed -e s/\\///)
  gp preview "${URL}${ENDPOINT}"
}

function browse-home () {
  browse-url "/"
}

function browse-wpadmin () {
  browse-url "/wp-admin"
}

function browse-dbadmin () {
  browse-url "/database"
}

function browse-phpinfo () {
  browse-url "/phpinfo"
}

function browse-emails () {
  browse-url "/" "8025"
}

export -f browse-url
export -f browse-home
export -f browse-wpadmin
export -f browse-dbadmin
export -f browse-phpinfo
export -f browse-emails

# use Node.js LTS
nvm use lts/* > /dev/null
export NODE_VERSION=$(node -v | sed 's/v//g')

# WP-CLI auto completion
. $HOME/wp-cli-completion.bash
