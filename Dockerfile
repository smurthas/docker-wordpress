FROM ubuntu:latest
MAINTAINER John Fink <john.fink@gmail.com>
RUN apt-get update # Mon Jan 27 11:35:22 EST 2014
#RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-setuptools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install vim-tiny
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-ldap
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install sudo
RUN easy_install supervisor
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf
RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers
RUN rm -rf /var/www/
RUN curl http://wordpress.org/latest.tar.gz > /tmp/wordpress.tar.gz
RUN tar xvzf /tmp/wordpress.tar.gz
RUN mv /wordpress /var/www/
RUN chown -R www-data:www-data /var/www/
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir /var/log/supervisor/
RUN mkdir /var/run/sshd
EXPOSE 80
EXPOSE 22
CMD ["/bin/bash", "/start.sh"]
