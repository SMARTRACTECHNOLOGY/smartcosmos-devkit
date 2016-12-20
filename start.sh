#!/bin/bash
#
# Start the DevKit services separately to speed up the process.

set -e

prerequisites() {
  echo "\n→ Starting database and message queue services..."
  docker-compose up -d mysql zookeeper kafka
}

configserver() {
  readonly HTTP_OK="200"
  readonly CONFIG_SERVER_STATUS_URL="http://localhost:8888/admin/status"
  readonly DELAY=5

  echo "\n→ Starting config-server..."

  docker-compose up -d config-server

  attempt=0
  started=false
  echo "Waiting for the server to become available..."
  while [ $started = false ] && [ $attempt -lt 10 ]
  do
    set +e
    status=$(curl -s -o /dev/null -w "%{http_code}" $CONFIG_SERVER_STATUS_URL)
    set -e
    if [ $HTTP_OK = $status ]
    then
      started=true
    else
      sleep $((attempt*DELAY))s
    fi
    attempt=$((attempt + 1))
  done

  if [ $attempt -eq 10 ] && [ $started = false ]
  then
    err "The config server did not respond "
  fi
}

auth() {
  echo "\n→ Starting user and auth services..."
  docker-compose up -d edge-user-devkit user-details-devkit auth-server
}

core() {
  echo "\n→ Starting core services..."
  docker-compose up -d ext-relationships ext-metadata ext-things edge-things
}

events() {
  echo "\n→ Starting event service..."
  docker-compose up -d events
}

ui() {
  echo "\n→ Starting user interface..."
  docker-compose up -d ui
}

gateway() {
  echo "\n→ Starting gateway..."
  docker-compose up -d gateway
}

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

main() {
  START=$(date +%s)

  echo "Welcome to SMART COSMOS DevKit"
  echo "=============================="

  prerequisites
  configserver
  auth
  core
  events
  ui
  gateway

  END=$(date +%s)
  DIFF=$(( $END - $START ))
  echo "\nStarting the SMART COSMOS DevKit took $DIFF seconds.\n"
  echo "→ Services started:\n$ docker ps\n"
  docker ps
  echo "\nNote that it will take a while until they are available and can answer requests!"
}

main "$@"
