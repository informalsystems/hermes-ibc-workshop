# Channel

In this step, we will establish a channel between the chains

## Channel Handshake

The steps below need to succeed in order to have a channel opened between chain-a and chain-b

### ChanOpenInit

```
hermes -c ./config.toml tx raw chan-open-init chain-a chain-b connection-0 transfer transfer -o UNORDERED | jq
```

### ChanOpenTry

```
hermes -c ./config.toml tx raw chan-open-try chain-b chain-a connection-0 transfer transfer -s channel-0 | jq
```

### ChanOpenAck

```
hermes -c ./config.toml tx raw chan-open-ack chain-a chain-b connection-0 transfer transfer -d channel-0 -s channel-0 | jq
```

### ChanOpenConfirm

```
hermes -c ./config.toml tx raw chan-open-confirm chain-b chain-a connection-0 transfer transfer -d channel-0 -s channel-0 | jq
```

## Query channel

Use these commands to query the channel end on each chain

```
hermes -c ./config.toml query channel end chain-a transfer channel-0 | jq
```

```
hermes -c ./config.toml query channel end chain-b transfer channel-0 | jq
```