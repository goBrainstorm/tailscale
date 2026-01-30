#!/bin/bash

# this script is used to wake up a device in the tailscale network from your local machine

# Load variables from the .env file in the current directory

source "$(dirname "$0")/.env" || { echo ".env file not found"; exit 1; }

# Arrays to store device names and MAC addresses
declare -a device_names
declare -a mac_addresses

# Parse MAC_ variables from .env file
while IFS='=' read -r var value; do
    if [[ "$var" =~ ^MAC_ ]]; then
        device_name="${var#MAC_}"
        # Remove quotes from value if present
        mac="${value//\"/}"
        device_names+=("$device_name")
        mac_addresses+=("$mac")
    fi
done < <(grep '^MAC_' "$(dirname "$0")/.env")

# Check if any devices were found
if [ ${#device_names[@]} -eq 0 ]; then
    echo "No devices found in .env file"
    exit 1
fi

# Display numbered list of devices
echo "Available devices in .env:"
for i in "${!device_names[@]}"; do
    echo "$((i+1)). ${device_names[$i]}"
done

# Prompt user for selection
echo ""
read -p "Select device number (1-${#device_names[@]}): " selection

# Validate input
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#device_names[@]} ]; then
    echo "Invalid selection"
    exit 1
fi

# Get the selected MAC address (convert to 0-based index)
index=$((selection - 1))
target_mac="${mac_addresses[$index]}"

echo "Selected device: ${device_names[$index]}"
echo "MAC address: $target_mac"

echo "Waking up device..."

# Execute the command
wakeonlan "$target_mac"