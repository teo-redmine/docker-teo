FROM sameersbn/redmine:3.1.1-3
MAINTAINER juan.leal@juntadeandalucia.es

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server libxml2-dev libxslt1.1 libxslt1-dev build-essential libssh2-1 libssh2-1-dev cmake libgpg-error-dev

RUN mkdir ${REDMINE_HOME}/teo-plugins
#COPY assets/themes/ ${REDMINE_INSTALL_DIR}/public/themes
COPY assets/plugins ${REDMINE_INSTALL_DIR}/teo-plugins
COPY assets/setup/sudoers /etc/sudoers.d/redmine

# redmine_git_hosting
RUN adduser --disabled-password --gecos git git
RUN su - ${GITOLITE_USER} -c " \
 mkdir -p ${GITOLITE_HOME}/bin; \
 git clone https://github.com/sitaramc/gitolite.git; \
 cd gitolite; \
 git checkout v3.6.6; \
 ./install -to ${GITOLITE_HOME}/bin"
RUN update-rc.d ssh defaults
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/jbox-web/redmine_bootstrap_kit.git \
 && cd redmine_bootstrap_kit/ \
 && git checkout 0.2.4
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/teo-redmine/redmine_git_hosting.git \
 && cd redmine_git_hosting/ \
 && git checkout 328cc949fb7d167613de9b1730c8e1de01d1a6ee \
 && grep -rl "gem 'dalli'" . | xargs sed -i "s/gem 'dalli'/#gem 'dalli'/g"

# redmine_favorite_projects
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/alexandermeindl/redmine_favorite_projects.git \
 && cd redmine_favorite_projects \
 && git checkout ef903d083cb3006fe1dc990ab06f26e7c3b76879

# teo_project_overview
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/teo-redmine/teo_project_overview.git \
 && cd teo_project_overview \
 && git checkout a813bcff132c51c9d0b1b39502aabe1ec5446ce7

# hgp_cmis and redmine_progress_reports
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/teo-redmine/additional_hooks.git \
 && cd additional_hooks \
 && git checkout 546727e9440ef14354160a295a3ff0e0b75df06b
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/teo-redmine/hgp_cmis.git \
 && cd hgp_cmis \
 && git checkout 2b9d460bdeeb02ead80d36ac1b5ffe78442c18f3
#RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
# && git clone https://github.com/teo-redmine/redmine_progress_reports.git \
# && cd redmine_progress_reports \
# && git checkout c582994bdf75755c2c1e68ce9223635b49397375

# teo_related_issues
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/teo-redmine/teo_related_issues.git \
 && cd teo_related_issues \
 && git checkout 774bdf83d2246dfa58f752b05fa8f6ef95fecb4d

# teo_extended_fields
RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/teo-redmine/teo_extended_fields.git \
 && cd teo_extended_fields \
 && git checkout 5bad27a5a5114efa404c4de2e2bd3111cc4b9292

COPY assets/setup/restart /sbin/restart
RUN chmod 755 /sbin/restart
EXPOSE 80/tcp 443/tcp 22/tcp
VOLUME ["${REDMINE_DATA_DIR}", "${REDMINE_LOG_DIR}"]
COPY teo-entrypoint.sh /sbin/teo-entrypoint.sh
RUN chmod 755 /sbin/teo-entrypoint.sh
WORKDIR ${REDMINE_INSTALL_DIR}
ENTRYPOINT ["/sbin/teo-entrypoint.sh"]
CMD ["app:start"]

