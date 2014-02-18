# Lots of credit to https://github.com/jbfink/docker-wordpress for getting
# things going. I started with a fork of that project and have now diverged
# quite a bit

FROM ubuntu:latest

MAINTAINER Simon Murtha Smith <simon@murtha-smith.com>

RUN apt-get update

# basic tools
RUN apt-get -y install curl
RUN apt-get -y install pwgen
RUN apt-get -y install python-setuptools
RUN apt-get -y install sudo

# apache
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5

# php
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-ldap

# supervisor
RUN easy_install supervisor

# some cleanup
RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers
RUN rm -rf /var/www/

# install wordpress
RUN curl http://wordpress.org/latest.tar.gz > /tmp/wordpress.tar.gz
RUN tar xvzf /tmp/wordpress.tar.gz
RUN mv /wordpress /var/www/
RUN chown -R www-data:www-data /var/www/

RUN mkdir /var/log/supervisor/

# add our scripts and config
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf

# make things executable
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh

# apache will bind to port 80
EXPOSE 80
CMD ["/bin/bash", "/start.sh"]
