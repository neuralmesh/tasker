#!/bin/bash

# Ensure jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq to run this script."
    exit 1
fi

# Load configuration from config.json
CONFIG="config.json"
NAME=$(jq -r '.NAME' "$CONFIG")
REPO_URL=$(jq -r '.REPO_URL' "$CONFIG")

# Collect all port mappings into a single string
PORT_MAPPINGS=$(jq -r '.PORT_MAPPINGS[] | "\(.PORT_EXTERN):\(.PORT_INTERN)"' "$CONFIG" | tr '\n' ' ')

# Call llmos.sh with the necessary arguments
./llmos.sh "$REPO_URL" "$NAME" "$PORT_MAPPINGS"

