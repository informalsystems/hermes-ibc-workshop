
# Clients

In this section we will configure the light clients for Hermes 

## Configure Light Clients

Open a terminal prompt. Move into the `relayer` directory:

```
cd ./relayer
```

### Remove light clients for each chain

In order to ensure the light clients configuration is right, let's clean up any previous configuration:

```
hermes -c ./config.toml light rm -c chain-a --all -y
```

```
hermes -c ./config.toml light rm -c chain-b --all -y
```

### Create light client store path for each chain

We need to manually add the folders for the light clients

```
mkdir -p $HOME/.hermes/chains/chain-a/ibc
```

```
mkdir -p $HOME/.hermes/chains/chain-b/ibc
```

### Add the primary node for each chain

```
hermes -c ./config.toml light add tcp://localhost:26657 -c chain-a -s $HOME/.hermes/chains/chain-a/ibc/ -p -y -f
```

```
hermes -c ./config.toml light add tcp://localhost:26557 -c chain-b -s $HOME/.hermes/chains/chain-b/ibc/ -p -y -f
```

### Add the witness node for each chain

```
hermes -c ./config.toml light add tcp://localhost:26657 -c chain-a -s $HOME/.hermes/chains/chain-a/ibc/ -y --peer-id 2427F8D914A6862279B3326FA64F76E3BC06DB2E --force
```

```
hermes -c ./config.toml light add tcp://localhost:26557 -c chain-b -s $HOME/.hermes/chains/chain-b/ibc/ -y --peer-id A885BB3D3DFF6101188B462466AE926E7A6CD51E --force
```

> Those peeer ids are arbitraty ones, they are currently not validated

## Configure Keys

### Add keys for each chain

These keys will be used by Hermes to sign transactions sent to each chain. The keys need to have a balance on each respective chain in order to pay for the transactions.

```
hermes -c ./config.toml keys add chain-a ../chains/chain-a/alice_key.json 
```

```
hermes -c ./config.toml keys add chain-b ../chains/chain-b/bob_key.json 
```

### List keys

To ensure the keys were properly added let's list them.

```
hermes -c ./config.toml keys list chain-a
```

```
hermes -c ./config.toml keys list chain-b
```

## Create client

Create a chain-b client on chain-a:

```
hermes -c ./config.toml tx raw create-client chain-a chain-b | jq
```

Query the client state

```
hermes -c ./config.toml query client state chain-a 07-tendermint-0 | jq
```

Create a chain-a client on chain-b

```
hermes -c ./config.toml tx raw create-client chain-b chain-a | jq
```

Query the client state

```
hermes -c ./config.toml query client state chain-b 07-tendermint-0 | jq
```

## Update client

Update the chain-b client on chain-a

```
hermes -c ./config.toml tx raw update-client chain-a chain-b 07-tendermint-0 | jq
```

Query the client state

```
hermes -c ./config.toml query client state chain-a 07-tendermint-0 | jq
```

## Next Setps

Next we will [establish a connection handshake](./connection.md)