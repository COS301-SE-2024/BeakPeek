#!/bin/bash

# Directory containing the .csv files
directory="../../res/species/"

# Loop through each .csv file in the directory
find "$directory" -name "*.csv" | while read -r file; do
    echo "Processing file: $file"
    grep -o --no-filename '^[0-9]\{4\}_[0-9]\{4\}' "$file" | sort | uniq | while read -r digits; do
        echo "$digits"
    done
done
