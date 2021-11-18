#!/bin/bash

trap 'read -p "run: $BASH_COMMAND"' DEBUG

#----------------------------------------------------
# HERMES - CONFIGURE
#----------------------------------------------------

# Add keys

# Earth key
hermes -c ./config.toml keys add earth -f ./earth_tellurian_key.json 

# Mars key
hermes -c ./config.toml keys add earth -f ./mars_greenman_key.json

# List keys
hermes -c ./config.toml keys list earth
hermes -c ./config.toml keys list mars

#----------------------------------------------------
# HERMES - START RELAYER
#----------------------------------------------------

# Send packets

# query balance - alice
chain-a --node tcp://localhost:26657 query bank balances $(chain-a --home $HOME/.chain-a keys --keyring-backend="test" show alice -a)

# query balance - bob
chain-b --node tcp://localhost:26557 query bank balances $(chain-b --home $HOME/.chain-b keys --keyring-backend="test" show bob -a)

# fungible token transfer 
hermes -c ~/.hermes/starport.toml tx raw ft-transfer chain-a chain-b transfer channel-0 999 1000 -n 1 -d coina | jq

# view response
echo "[DATA]" | xxd -r -p | jq

# query packet commitments
hermes -c ~/.hermes/starport.toml query packet commitments chain-a transfer channel-0 | jq

# query unreceived packets on chain b
hermes -c ~/.hermes/starport.toml query packet unreceived-packets chain-b chain-a transfer channel-0 | jq

# send recv_packet to chain b
hermes -c ~/.hermes/starport.toml tx raw packet-recv chain-b chain-a transfer channel-0 | jq

# query unreceived ack on chain a
hermes -c ~/.hermes/starport.toml query packet unreceived-acks chain-a chain-b transfer channel-0 | jq

# sent ack to chain a
hermes -c ~/.hermes/starport.toml tx raw packet-ack chain-a chain-b transfer channel-0 | jq

# query balance - bob
chain-b --node tcp://localhost:26557 query bank balances $(chain-b --home $HOME/.chain-b keys --keyring-backend="test" show bob -a)

# view denom trace
curl http://localhost:1318/ibc/applications/transfer/v1beta1/denom_traces/[denom]

# send packet with low timeout (height offset)
hermes -c ~/.hermes/starport.toml tx raw ft-transfer chain-a chain-b transfer channel-0 999 2 -n 1 -d coina | jq

# send timeout to chain-a
hermes -c ~/.hermes/starport.toml tx raw packet-recv chain-b chain-a transfer channel-0 | jq

# send tokens back to chain-a
hermes -c ~/.hermes/starport.toml tx raw ft-transfer chain-b chain-a transfer channel-0 999 1000 -n 1 -d ibc/4B2D39E31F5679FE011A8DE25CD886EA8F7754F9F45CADD7C7BD1BB315247DFD | jq

# send recv_packet to chain b
hermes -c ~/.hermes/starport.toml tx raw packet-recv chain-a chain-b transfer channel-0 | jq

# sent ack to chain b
hermes -c ~/.hermes/starport.toml tx raw packet-ack chain-b chain-a transfer channel-0 | jq