# Pull base image.
FROM debian:stretch

LABEL name="Learning Locker docker image"

#update and run install script for Learning locker
RUN set -xe \
    && apt-get update \
	&& apt-get upgrade -y
	
RUN set -xe \
    && apt-get install -y \
	curl \
	git \
	git-core \
	python \
	make \
	automake \
	build-essential \
	xvfb \
	apt-transport-https
	
RUN set -xe \
    && curl -o- -L http://lrnloc.kr/installv2 > deployll.sh \
	&& bash deployll.sh -y 3
	
#we don't want this service running on startup, we want to start it after string replace.
RUN service pm2-learninglocker off

COPY files/webapp.env /usr/local/learninglocker/current/webapp/.env
COPY files/xapi.env /usr/local/learninglocker/current/xapi/.env

COPY files/entrypoint.sh /entrypoint.sh 

RUN chmod +x /entrypoint.sh

VOLUME ["/var/lib/mongo"]

# Define default command.
ENTRYPOINT ["/entrypoint.sh"]
CMD ["pm2 logs"]