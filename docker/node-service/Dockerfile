FROM mhart/alpine-node:6.3

MAINTAINER SMART COSMOS Platform Core Team

# Create smartcosmos user
RUN adduser -S smartcosmos -u 1000

# switch to smartcosmos user
USER smartcosmos

# Create base directory for the jar
RUN mkdir -p /opt/smartcosmos && \
        chown -R smartcosmos /opt/smartcosmos
