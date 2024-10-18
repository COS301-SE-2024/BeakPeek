#!/bin/bash

if [[ -z "$1" ]]; then
    echo "No proince list"
    exit 1
else
    PROVINCE_LIST="$1"
    echo "Given province list"
fi

if [[ -z "$2" ]]; then
    URL="http://localhost:5050"
    echo "Using default Url"
else
    URL="$2"
    echo "Using given URL"
fi

BIRDS=birds.csv
if [[ -z "$3" ]]; then
    echo "Getting birds"
    curl -L -o birds.csv "https://api.birdmap.africa/sabap2/v2/coverage/country/southafrica/species?format=csv"
else
    IS_TEST=true
    BIRDS=$3
    echo "Test mode"
fi

GOOD_BIRDS=$(awk -F, 'BEGIN {FS=","} {if ($6 > 0.01 ) print $0}' $BIRDS)
echo "$GOOD_BIRDS" > good_birds.csv

curl -X 'POST' \
  "$URL/api/Import/importBirds" \
  -H 'accept: */*' \
  -H 'Content-Type: multipart/form-data' \
  -F 'file=@good_birds.csv;type=text/csv'

base_url="https://api.birdmap.africa/sabap2/v2/monthly/speciesbypentad/province/"

set -o pipefail
while IFS= read -r line
do
    FULL_URL="${base_url}${line}?period=&dates=&format=csv"

    echo "Downloading ${line} CSV"

    if curl -L "$FULL_URL" -o ${line}.csv  ; then
    if [[ IS_TEST ]]; then
        awk '{FS=","} {print } NR==10{exit}' ${line}.csv > ${line}_short.csv
        cat ${line}_short.csv
    fi
    curl -X 'POST' \
        "$URL/api/Import/import?province=${line}" \
        -H 'accept: */*' \
        -H 'Content-Type: multipart/form-data' \
        -F "file=@${line}_short.csv;type=text/csv"
    fi
done < "$PROVINCE_LIST"
