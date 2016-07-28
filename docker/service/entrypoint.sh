#!/bin/sh

exec dockerize -timeout 5m -wait ${CONFIG_SERVER_URL}/admin/status java $JAVA_OPTS -jar $@
