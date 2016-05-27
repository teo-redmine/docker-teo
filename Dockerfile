FROM sameersbn/redmine:3.1.1-3
MAINTAINER juan.leal@juntadeandalucia.es

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server libxml2-dev libxslt1.1 libxslt1-dev build-essential libssh2-1 libssh2-1-dev cmake libgpg-error-dev

COPY assets/setup/restart /sbin/restart
RUN chmod 755 /sbin/restart
EXPOSE 80/tcp 443/tcp 22/tcp
VOLUME ["${REDMINE_DATA_DIR}", "${REDMINE_LOG_DIR}"]
COPY teo-entrypoint.sh /sbin/teo-entrypoint.sh
RUN chmod 755 /sbin/teo-entrypoint.sh
WORKDIR ${REDMINE_INSTALL_DIR}
ENTRYPOINT ["/sbin/teo-entrypoint.sh"]
CMD ["app:start"]

