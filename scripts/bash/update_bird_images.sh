#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 path_to_csv_file"
    exit 1
fi

# Specify the CSV file from the argument and the API endpoint
CSV_FILE="$1"
API_BASE_URL="https://beakpeekbirdapi.azurewebsites.net/api/bird"

# Check if the file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' not found!"
    exit 1
fi

# Loop through each row starting from the second row and extract the first column
awk -F',' 'NR > 1 {print $1}' "$CSV_FILE" | while read -r VALUE
do
    # Construct the URL and make the request with curl
    URL="${API_BASE_URL}/${VALUE}"
    echo "Making request to: $URL"

    # Make the API request
    RESPONSE=$(curl -s -X GET $URL)

    # Print the response (you can handle the response however needed)
    echo "Response: $RESPONSE"
done
