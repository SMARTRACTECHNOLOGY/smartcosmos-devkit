#!/bin/sh

spring_profile_options=""
if [[ ! -z "${SPRING_PROFILE}" ]]; then
  spring_profile_options="-Dspring.profiles.active=${SPRING_PROFILE}"
fi

if [[ -z "${SPRING_CONFIG_LOCATION}" ]]; then
  exec dockerize -timeout 5m -wait ${CONFIG_SERVER_URL}/admin/status \
        java $JAVA_OPTS ${spring_profile_options} \
        -jar $@ $SERVER_PORT $SPRING_PARAMETERS
else
  exec java $JAVA_OPTS ${spring_profile_options} \
        -jar $@ $SERVER_PORT $SPRING_CONFIG_LOCATION $SPRING_PARAMETERS
fi
