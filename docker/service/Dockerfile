FROM smartcosmos/java:latest

MAINTAINER SMART COSMOS Platform Core Team


# download dockerize script, this is used to wait for the config server
ADD https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz dockerize.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize.tar.gz

COPY entrypoint.sh entrypoint.sh

# Create smartcosmos user
RUN adduser -S smartcosmos -u 1000

# Create base directory for the jar
RUN mkdir -p /opt/smartcosmos && \
        chown -R smartcosmos /opt/smartcosmos


ENV CONFIG_SERVER_URL 'http://config-server:8888'
ENV JAVA_OPTS='-Xmx512m'

# expose default service port
EXPOSE 8080

# switch to smartcosmos user
USER smartcosmos

ENTRYPOINT ["./entrypoint.sh"]
