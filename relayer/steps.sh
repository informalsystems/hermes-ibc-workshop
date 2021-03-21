
#!/bin/sh


# Create connection chain-a -> chain-b

# conn-init
hermes -c ~/.hermes/starport.toml tx raw conn-init chain-a chain-b 07-tendermint-0 07-tendermint-0 | jq

# conn-try
hermes -c ~/.hermes/starport.toml tx raw conn-try chain-b chain-a 07-tendermint-0 07-tendermint-0 -s connection-0 | jq

# conn-ack
hermes -c ~/.hermes/starport.toml tx raw conn-ack chain-a chain-b 07-tendermint-0 07-tendermint-0 -d connection-0 -s connection-0 | jq

# conn-confirm
hermes -c ~/.hermes/starport.toml tx raw conn-confirm chain-b chain-a 07-tendermint-0 07-tendermint-0 -d connection-0 -s connection-0 | jq


# Query connection
hermes -c ~/.hermes/starport.toml query connection end chain-a connection-0 | jq
hermes -c ~/.hermes/starport.toml query connection end chain-b connection-0 | jq

# Create a channel 

# chan-open-init
hermes -c ~/.hermes/starport.toml tx raw chan-open-init chain-a chain-b connection-0 transfer transfer -o UNORDERED | jq

# chan-open-try
hermes -c ~/.hermes/starport.toml tx raw chan-open-try chain-b chain-a connection-0 transfer transfer -s channel-0 | jq

# chan-open-ack
hermes -c ~/.hermes/starport.toml tx raw chan-open-ack chain-a chain-b connection-0 transfer transfer -d channel-0 -s channel-0 | jq

# chan-open-confirm
hermes -c ~/.hermes/starport.toml tx raw chan-open-confirm chain-b chain-a connection-0 transfer transfer -d channel-0 -s channel-0 | jq

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