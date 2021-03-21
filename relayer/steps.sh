
#!/bin/sh

#----------------------------------------------------
# STARPORT
#----------------------------------------------------

### NOTE: Do this for each chain, replace 'chain-a' with 'chain-b', 

# Create chain
#starport app github.com/andynog/chain-a --address-prefix chain-a

# Build chain
starport build

# Restore keys

# Alice
chain-a keys add alice --recover --home $HOME/.chain-a
oxygen soap solid wave swim dumb piece pass bronze horn bronze sweet acid radio reform clump team behind deer anxiety volcano reform jewel inspire

# Bob
chain-b keys add bob --recover --home $HOME/.chain-b
become observe excess guitar wreck planet treat artist oblige depart fix deposit uphold drift sick amount agree frame pilot transfer nerve guitar section tail

# Start chain
starport serve -c config.yml

# Query Alice's balance
chain-a --node tcp://localhost:26657 query bank balances $(chain-a --home $HOME/.chain-a keys --keyring-backend="test" show alice -a)

# Query Bob's balance
chain-b --node tcp://localhost:26557 query bank balances $(chain-b --home $HOME/.chain-b keys --keyring-backend="test" show bob -a)

#----------------------------------------------------
# HERMES
#----------------------------------------------------

# Remove light clients
hermes -c ~/.hermes/starport.toml light rm -c chain-a --all -y
hermes -c ~/.hermes/starport.toml light rm -c chain-b --all -y

# Create light client store path
mkdir -p $HOME/.hermes/chains/chain-a/ibc
mkdir -p $HOME/.hermes/chains/chain-b/ibc

# Primary
hermes -c ~/.hermes/starport.toml light add tcp://localhost:26657 -c chain-a -s $HOME/.hermes/chains/chain-a/ibc/ -p -y -f
hermes -c ~/.hermes/starport.toml light add tcp://localhost:26557 -c chain-b -s $HOME/.hermes/chains/chain-b/ibc/ -p -y -f

# Witness
hermes -c ~/.hermes/starport.toml light add tcp://localhost:26657 -c chain-a -s $HOME/.hermes/chains/chain-a/ibc/ -y --peer-id 2427F8D914A6862279B3326FA64F76E3BC06DB2E --force
hermes -c ~/.hermes/starport.toml light add tcp://localhost:26557 -c chain-b -s $HOME/.hermes/chains/chain-b/ibc/ -y --peer-id A885BB3D3DFF6101188B462466AE926E7A6CD51E --force

# Add keys
hermes -c ~/.hermes/starport.toml keys add chain-a /home/andy/development/starport/chaina/alice_key.json 
hermes -c ~/.hermes/starport.toml keys add chain-b /home/andy/development/starport/chainb/bob_key.json 

# List keys
hermes -c ~/.hermes/starport.toml keys list chain-a
hermes -c ~/.hermes/starport.toml keys list chain-b

# Create clients

# create a chain-b client on chain-a
hermes -c ~/.hermes/starport.toml tx raw create-client chain-a chain-b | jq

# query the client state
hermes -c ~/.hermes/starport.toml query client state chain-a 07-tendermint-0 | jq

# update the chain-b client on chain-a
hermes -c ~/.hermes/starport.toml tx raw update-client chain-a chain-b 07-tendermint-0 | jq

# query the client state
hermes -c ~/.hermes/starport.toml query client state chain-a 07-tendermint-0 | jq

# create a chain-a client on chain-b
hermes -c ~/.hermes/starport.toml tx raw create-client chain-b chain-a | jq

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