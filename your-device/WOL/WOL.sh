#!/bin/bash

# this script is used to wake up a device in the tailscale network from your local machine with a jump host

# Load variables from the .env file in the current directory

source "$(dirname "$0")/.env" || { echo ".env file not found"; exit 1; }

echo "Name of device: "
# TODO: abfrage → user input → store var "target_mac"
target_mac = ""

echo "Connecting to $JUMP_HOST to wake target..."

# Execute the command
ssh "$JUMP_USER@$JUMP_HOST" "wakeonlan $target_mac"