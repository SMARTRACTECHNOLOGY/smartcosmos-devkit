FROM alpine:3.4
#FROM davidcaste/alpine-java-unlimited-jce

MAINTAINER The SMART COSMOS Authors

RUN apk --update add openjdk8-jre

CMD ["java", "-version"]
