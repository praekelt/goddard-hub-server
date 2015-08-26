# Base image for ubuntu 14.04
FROM iodigital/ubuntu-node:v1
MAINTAINER io <devops@io.co.za>

sudo apt-get install python-psycopg2 -y

ENV NODE_PORT 8080
ENV NODE_ENV production

ENV AUTHED_KEYS_FILE /home/node/.ssh/authorized_keys
ENV APP_FOLDER_PATH /var/goddard/apps/
ENV LOG_FOLDER_PATH /var/log/node/

VOLUME ["/var/goddard/apps", "/home/node/.ssh", "/var/log/node/"]

