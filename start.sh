#!/bin/bash
MYSQL_HOST=$MYSQL_PORT_3306_TCP_ADDR

if [[ -z "$MYSQL_HOST" ]]
then
  echo "invalid mysql host:" $MYSQL_HOST
  exit 1
fi


# set some defaults
if [[ -z "$WP_DB" ]]
then
  WP_DB="wordpress"
fi

# update the wp config with the passed in values
sed -e "s/database_name_here/$WP_DB/
s/username_here/$WP_USER/
s/password_here/$WP_PASS/
s/localhost/$MYSQL_HOST/
/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /var/www/wp-config-sample.php > /var/www/wp-config.php

mv /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.orig
sed "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php5/apache2/php.ini.orig > /etc/php5/apache2/php.ini


chown www-data:www-data /var/www/wp-config.php

supervisord -n
