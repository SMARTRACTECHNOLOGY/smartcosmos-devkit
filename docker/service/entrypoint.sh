#!/bin/sh

if [[ -z "${SPRING_CONFIG_LOCATION// }" ]]; then
  exec dockerize -timeout 5m -wait ${CONFIG_SERVER_URL}/admin/status \
        java $JAVA_OPTS -Dspring.profiles.active=${SPRING_PROFILE} \
        -jar $@ $SERVER_PORT $SPRING_PARAMETERS
else
  java $JAVA_OPTS -Dspring.profiles.active=${SPRING_PROFILE} \
        -jar $@ $SERVER_PORT $SPRING_CONFIG_LOCATION $SPRING_PARAMETERS
fi
