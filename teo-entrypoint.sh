#!/bin/bash

if [ ! -d "${REDMINE_DATA_DIR}/tmp/" ]; then
  echo
  echo "INSTALLING REDMINE FOR THE FIRST TIME"
  /sbin/entrypoint.sh app:init
fi

if [ ! -d "${REDMINE_DATA_DIR}/plugins/" ]; then
  echo
  echo "INSTALLING DEFAULT PLUGINS AND THEMES"
  cp -r ${REDMINE_INSTALL_DIR}/teo-plugins ${REDMINE_DATA_DIR}/plugins
  cp -r ${REDMINE_INSTALL_DIR}/public/themes ${REDMINE_DATA_DIR}/themes
fi;

# Configure container if just created
if cmp -s config/database.yml config/database.yml.example
then
  echo "Configuring container for the first time"
  /sbin/entrypoint.sh app:init
fi

service ssh start
if [ -e "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig" ]; then
  cp "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig" "${REDMINE_INSTALL_DIR}/config/environments/production.rb"
fi

echo
echo "Waiting for mysql server to be ready..."
cd "${REDMINE_INSTALL_DIR}"
until bundle exec rake db:version &> /dev/null
do
  echo "Trying again..."
done
echo "mysql server ready."

# Setup for easier development process
if [ $TEO_ENV = "development" ]; then
  echo "Linking to data-dir plugins"
  if [ -d "${REDMINE_INSTALL_DIR}/plugins" ]; then
    rm -rf "${REDMINE_INSTALL_DIR}/plugins"
  fi
  if [ ! -L "${REDMINE_INSTALL_DIR}"/plugins ]; then
    ln -s "${REDMINE_DATA_DIR}/plugins/" "${REDMINE_INSTALL_DIR}"
  fi
  echo "Disabling caches"
  if [ ! -e "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig" ]; then
    cp "${REDMINE_INSTALL_DIR}/config/environments/production.rb" "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig"
  fi
  cp "${REDMINE_INSTALL_DIR}/config/environments/development.rb" "${REDMINE_INSTALL_DIR}/config/environments/production.rb"

  echo "Activating DEBUG log level"
  echo "config.log_level = :debug" >> ${REDMINE_INSTALL_DIR}/config/additional_environment.rb
  mkdir -p log
  touch log/production.log
  tail -n0 -f log/production.log &
fi
/sbin/entrypoint.sh "$@"
