FROM mhart/alpine-node:6.3

MAINTAINER SMART COSMOS Platform Core Team

# XXX temporarily add python to resolve node-sass issue.
RUN apk add --no-cache python

# Create smartcosmos user
RUN adduser -S smartcosmos -u 1000

# Create base directory for the jar
RUN mkdir -p /opt/smartcosmos && \
        chown -R smartcosmos /opt/smartcosmos

# switch to smartcosmos user
USER smartcosmos
