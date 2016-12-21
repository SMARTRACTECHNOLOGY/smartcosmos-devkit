#!/bin/bash
#
# Start the DevKit services separately to speed up the process.

set -e

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly ORANGE='\033[0;33m'
readonly DEFAULT_COLOR='\033[0m'

function http_get_succeeds() {
  local readonly URL=${1}
  local readonly HTTP_OK="200"
  local readonly UNDEFINED_STATUS="000"
  local readonly MAX_ATTEMPTS=15
  local readonly DELAY=2

  local attempt=0
  local started=false
  local status=${UNDEFINED_STATUS}

  while [ $started = false ] && [ $attempt -lt 10 ]; do
    set +e
    status=$(curl -s -o /dev/null -w "%{http_code}" ${URL})
    set -e
    if [ ${UNDEFINED_STATUS} = ${status} ]
    then
      sleep $((attempt*DELAY))s & spinner
    else
      started=true
    fi
    attempt=$((attempt + 1))
  done

  if [ ${attempt} -eq ${MAX_ATTEMPTS} ] && [ ${started} = false ]; then
    return 1
  else
    return 0
  fi
}

function container_is_up() {
  local readonly NAME=${1}
  local container_count=$(docker-compose ps | grep -E "$NAME" | wc -l)
  local container_up_count=$(docker-compose ps | grep -E "$NAME" | grep "Up" | wc -l)

  if [ ${container_count} -eq ${container_up_count} ]; then
    return 0
  else
    return 1
  fi
}

function spinner() {
    local pid=$!
    local s='-\|/';
    local i=0;

    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
      i=$(( (i+1) %4 ))
      printf "\r${s:$i:1}"
      sleep .15
    done

    printf "\b\b\b\b\b\b"
    printf "    \b\b\b\b"
}

function err() {
  echo "${RED}✗${DEFAULT_COLOR} $@" >&2
}

function prerequisites() {
  echo "\n${ORANGE}→ Starting database and message queue services...${DEFAULT_COLOR}"
  docker-compose up -d mysql zookeeper kafka
}

function configserver() {
  local readonly CONFIG_SERVER_STATUS_URL="http://localhost:8888/admin/status"

  echo "\n${ORANGE}→ Starting config-server...${DEFAULT_COLOR}"

  docker-compose up -d config-server

  echo "Waiting for the server to become available..."

  if http_get_succeeds ${CONFIG_SERVER_STATUS_URL}; then
    echo "${GREEN}✓${DEFAULT_COLOR} Done."
  else
    err "The config server did not respond. It may become available later, please check the log:\n$ docker-compose logs -f config-server"
  fi
}

function services() {
  echo "\n${ORANGE}→ Starting user and auth services...${DEFAULT_COLOR}"
  docker-compose up -d edge-user-devkit user-details-devkit auth-server
  if ! container_is_up "edge-user-devkit|user-details-devkit|auth-server"; then
    sleep 60s & spinner
  fi

  echo "\n${ORANGE}→ Starting core services...${DEFAULT_COLOR}"
  docker-compose up -d ext-relationships ext-metadata ext-things edge-things
  if ! container_is_up "ext-relationships|ext-metadata|ext-things|edge-things"; then
    sleep 90s & spinner
  fi

  echo "\n${ORANGE}→ Starting event service...${DEFAULT_COLOR}"
  docker-compose up -d events
  if ! container_is_up "events"; then
    sleep 10s & spinner
  fi

  echo "\n${ORANGE}→ Starting user interface...${DEFAULT_COLOR}"
  docker-compose up -d ui

  echo "\n${ORANGE}→ Starting gateway...${DEFAULT_COLOR}"
  docker-compose up -d gateway
}

function main() {
  START=$(date +%s)

  echo "${ORANGE}Welcome to SMART COSMOS DevKit${DEFAULT_COLOR}"

  prerequisites
  configserver
  services

  END=$(date +%s)
  DIFF=$(( $END - $START ))
  echo "\nStarting the ${bold}${ORANGE}SMART COSMOS DevKit${DEFAULT_COLOR} took ${DIFF} seconds.\n"
  echo "${ORANGE}→ Services started:${DEFAULT_COLOR}\n$ docker ps\n"
  docker ps
  echo "\nNote that it will take a few moments until they are available and can answer requests! 💡"

  if http_get_succeeds "http://localhost:8080"; then
    echo "${GREEN}You're ready to take off now! Enjoy your SMART COSMOS adventures!${DEFAULT_COLOR} 🚀"
  else
    err "The gateway did not respond. It may become available later, please check the log:\n$ docker-compose logs -f gateway"
  fi
}

main "$@"
