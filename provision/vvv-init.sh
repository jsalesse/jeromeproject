#!/usr/bin/env bash

# Add the site name to the hosts file
echo "127.0.0.1 ${VVV_SITE_NAME}.local # vvv-auto" >> "/etc/hosts"

# Make a database, if we don't already have one
echo -e "\nCreating database '${VVV_SITE_NAME}' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS ${VVV_SITE_NAME}"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON ${VVV_SITE_NAME}.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

if [ ! -d "${VVV_PATH_TO_SITE}/public_html/wp-admin" ]; then
  echo "Installation de Wordpress";
  if [ ! -d "${VVV_PATH_TO_SITE}/public_html" ]; then
    mkdir ${VVV_PATH_TO_SITE}/public_html
  fi
  
  cd ${VVV_PATH_TO_SITE}/public_html
  
  wp core download --path="${VVV_PATH_TO_SITE}/public_html" --allow-root
  wp core config --dbname="${VVV_SITE_NAME}" --dbuser=wp --dbpass=wp --quiet --allow-root
  wp core install --url="${VVV_SITE_NAME}.local" --title="premier projet" --admin_user=admin --admin_password=password --admin_email=antoine@firmecreative.com --allow-root
  
fi