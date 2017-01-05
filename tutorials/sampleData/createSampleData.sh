#!/bin/bash
#

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

# create new tenant, then extract username and password from the response
#respTenant=$curl -X POST -H "Content-Type: application/json" -d '{"active": true, "name": "Nervous Terrible Theory", "username": "finger@blood.com"}' "http://localhost:8080/tenants")
#respTenant=$(curl -sS -X POST -H "Content-Type: application/json" -d "$(cat createTenant.json)" "http://localhost:8080/tenants")

respTenant=$(cat respTenant.json)

echo ${respTenant}

tenantUsername=$(jsonGetSubValue ${respTenant} "admin" "username")
tenantPassword=$(jsonGetSubValue ${respTenant} "admin" "password")

echo " === User Credentials === "
echo ${tenantUsername}
echo ${tenantPassword}

# acquire authentication token
res=$(curl -sS -X POST -H "Content-Type: application/json" -H "Authorization: Basic c21hcnRjb3Ntb3NzZXJ2aWNlOjlIaG5ORGhmR0VYZk5FbjY=" "http://localhost:8080/oauth/token?grant_type=password&scope=read&username=$tenantUsername&password=$tenantPassword")
token=$(jsonGetValue ${res} "access_token")

echo " === JWT Token === "
echo ${token}

# send bulk import
respImport=$(curl -sS -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $token" -d "$(cat bulkimport.json)" "http://localhost:8080/bulkimport/")

echo " === Import result === "
echo ${respImport}


