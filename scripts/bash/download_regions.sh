#!/bin/bash

# curl -L -o gauteng.csv  https://api.birdmap.africa/sabap2/v2/monthly/speciesbypentad/province/gauteng\?period\=\&dates\=\&format\=csv
# curl -L -o easterncape.csv 

# province_list="../../scripts/bash/provinces.txt"
province_list="provinces.txt"

base_url="https://api.birdmap.africa/sabap2/v2/monthly/speciesbypentad/province/"

while IFS= read -r line
do
  FULL_URL="${base_url}${line}?period=&dates=&format=csv"

  echo "Downloading ${line} CSV"

  curl -L -o ${line}.csv "$FULL_URL"
done < "$province_list"
