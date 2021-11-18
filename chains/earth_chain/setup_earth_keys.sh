#!/bin/bash

trap 'read -p "run: $BASH_COMMAND"' DEBUG

# Delete key if exists
earthd keys delete tellurian -f

# Add key to keyring
echo "mother address various awake warrior shadow collect guide smart brother youth flee transfer later meadow round promote praise exhaust shaft luxury avocado language reward" | earthd keys add tellurian --recover

# List keys
earthd keys list
