FROM smartcosmos/java:latest

MAINTAINER SMART COSMOS Platform Core Team


# download dockerize script, this is used to wait for the config server
ENV DOCKERIZE_VERSION v0.2.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
        && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
        && rm -rf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


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
