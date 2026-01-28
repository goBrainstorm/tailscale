#!/bin/bash

# Load variables from the .env file in the current directory
# The "||" part stops the script if the file is missing
source "$(dirname "$0")/.env" || { echo ".env file not found"; exit 1; }

echo "Name of device: "
# TODO: abfrage → user input → store var "target_mac"
target_mac = ""

echo "Connecting to $JUMP_HOST to wake target..."

# Execute the command
ssh "$JUMP_USER@$JUMP_HOST" "wakeonlan $target_mac"