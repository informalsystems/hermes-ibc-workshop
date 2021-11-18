#!/bin/bash

trap 'read -p "run: $BASH_COMMAND"' DEBUG

# Delete key if exists
marsd keys delete greenman -f

# Add key to keyring
echo "finish sand shiver farm evolve awful rally disagree alcohol pipe mistake oppose discover affair flight web toilet educate average wisdom coyote paper faint ride" | marsd keys add greenman --recover

# List keys
marsd keys list

