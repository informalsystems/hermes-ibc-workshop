# Connection

In this section we will run all the steps required to establish a connection handshake 

## Connection Handshake (chain-a -> chain-b)

The steps below need to succeed in order to have a connection opened between chain-a and chain-b

### ConnOpenInit

```
hermes -c ./config.toml tx raw conn-init chain-a chain-b 07-tendermint-0 07-tendermint-0 | jq
```

### ConnOpenTry

```
hermes -c ./config.toml tx raw conn-try chain-b chain-a 07-tendermint-0 07-tendermint-0 -s connection-0 | jq
```

### ConnOpenAck

```
hermes -c ./config.toml tx raw conn-ack chain-a chain-b 07-tendermint-0 07-tendermint-0 -d connection-0 -s connection-0 | jq
```

### ConnOpenConfirm

```
hermes -c ./config.toml tx raw conn-confirm chain-b chain-a 07-tendermint-0 07-tendermint-0 -d connection-0 -s connection-0 | jq
```

# Query connection

The commands below allow you to query the connection state on each chain.

```
hermes -c ./config.toml query connection end chain-a connection-0 | jq
```

```
hermes -c ./config.toml query connection end chain-b connection-0 | jq
```