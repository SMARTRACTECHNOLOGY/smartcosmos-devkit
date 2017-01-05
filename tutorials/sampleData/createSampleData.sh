#!/bin/bash

################################################################################
# This script initializes the SMART COSMOS Devkit with initial sample data
#
# To achieve this, following steps will be done:
# 1. Create a new tenant and first (as defined in *createTenant.json*)
# 2. Request a new JWT token for the newly created user
# 3. Import Things, Metadata and Relationships (as defined in *bulkimport.json*)
#
# In addition to the devkit, the script requires python and cURL to work.
################################################################################

set -e

function jsonGetValue() {
    local readonly json=$1
    local readonly key=$2
    local readonly pythonScript="import json,sys; res=json.load(sys.stdin); print res['${key}']"

    echo $(echo ${json} | python -c "${pythonScript}")
}

function jsonGetSubValue() {
    local readonly json=$1
    local readonly key=$2
    local readonly subkey=$3
    local readonly pythonScript="import json,sys; res=json.load(sys.stdin); print res['${key}']['${subkey}']"

    echo $(echo ${json} | python -c "${pythonScript}")
}

# define the SMART COSMOS DevKit instance
devkitHost="http://localhost:8080"

# define the client credentials for OAuth
clientKey="smartcosmosservice"
clientSecret="9HhnNDhfGEXfNEn6"

# create new tenant, then extract username and password from the response
respTenant=$(curl -sS -X POST -H "Content-Type: application/json" -d "$(cat createTenant.json)" "${devkitHost}/tenants")

if [[ ${respTenant} == "" ]]; then
  echo "Error creating new tenant."
  exit
fi

#respTenant=$(cat respTenant.json)
#echo ${respTenant}

tenantUsername=$(jsonGetSubValue ${respTenant} "admin" "username")
tenantPassword=$(jsonGetSubValue ${respTenant} "admin" "password")

echo " === User Credentials === "
echo ${tenantUsername}
echo ${tenantPassword}

# acquire authentication token
respToken=$(curl -sS -X POST -H "Content-Type: application/json" --basic -u ${clientKey}:${clientSecret} "${devkitHost}/oauth/token?grant_type=password&scope=read&username=${tenantUsername}&password=${tenantPassword}")
token=$(jsonGetValue ${respToken} "access_token")

echo " === JWT Token === "
echo ${token}

# send bulk import
respImport=$(curl -sS -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${token}" -d "$(cat bulkimport.json)" "${devkitHost}/bulkimport/")

echo " === Import result === "
echo ${respImport}


