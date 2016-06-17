#!/bin/sh

dockerize -timeout 5m -wait ${CONFIG_SERVER_URL}/admin/status "$@"
