FROM smartcosmos/java
MAINTAINER SMART COSMOS Platform Core Team

ENV CONFIG_SERVER_URL 'http://config-server:8888'

ADD https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz dockerize.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize.tar.gz

ADD entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
