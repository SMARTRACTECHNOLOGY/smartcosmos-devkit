#!/bin/sh

if [ -z "$SPRING_CONFIG_LOCATION" ]; then
  java $JAVA_OPTS -jar $@ $SERVER_PORT $SPRING_CONFIG_LOCATION $SPRING_PARAMETERS 
else
  exec dockerize -timeout 5m -wait ${CONFIG_SERVER_URL}/admin/status java $JAVA_OPTS -jar $@ $SERVER_PORT $SPRING_CONFIG_LOCATION $SPRING_PARAMETERS
fi
