#!/bin/bash
#

# create new tenant
curl -X POST -H "Content-Type: application/json" -d '{"active": true, "name": "Nervous Terrible Theory", "username": "finger@blood.com"}' "http://localhost:8080/tenants"

# acquire authentication token
TOKEN=$(curl -sS -X POST -H "Content-Type: application/json" -H "Authorization: Basic c21hcnRjb3Ntb3NzZXJ2aWNlOjlIaG5ORGhmR0VYZk5FbjY=" "http://localhost:8080/oauth/token?grant_type=password&scope=read&username=finger@blood.com&password=RQJ1oQa2jCeb" | jq -r '.access_token')
