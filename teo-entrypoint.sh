#!/bin/bash

# Setup default plugins
if [ ! -d "${REDMINE_DATA_DIR}/tmp/" ]; then
  echo
  echo "INSTALLING REDMINE FOR THE FIRST TIME"
  /sbin/entrypoint.sh app:init
  echo
  echo "Installing default plugins..."
  mkdir -p "${REDMINE_DATA_DIR}/plugins/"
  cd "${REDMINE_DATA_DIR}/plugins/"
  git clone https://github.com/teo-redmine/teo_project_overview.git
  git clone https://github.com/teo-redmine/hgp_cmis.git
  git clone https://github.com/teo-redmine/additional_hooks.git
#  git clone https://github.com/teo-redmine/redmine_progress_reports.git
  git clone https://github.com/alexandermeindl/redmine_favorite_projects.git
fi;

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
  cd "${REDMINE_DATA_DIR}"
  mkdir -p log
  touch log/production.log
  tail -n0 -f log/production.log &
fi


/sbin/entrypoint.sh "$@"
