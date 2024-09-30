#!/bin/bash

for i in {1..1000}; do
  response=$(curl --request POST \
  'https://beakpeekuserapi.azurewebsites.net/User/Login' \
  --header 'Content-Type: application/json' \
  --data '{"email": "'"${i}"'@load","password": "Test@test1"}')

  token=$(echo $response )
  echo "found $token"

  if [ "$token" != "null" ] && [ -n "$token" ]; then
    second_response=$(curl --request GET 'https://beakpeekuserapi.azurewebsites.net/User/Delete' --header "Authorization: Bearer ${token}")
    echo "delete response: $second_response"
    echo "Deleted user $i@load"
  else
    echo "No user found with $i@load"
  fi
done
