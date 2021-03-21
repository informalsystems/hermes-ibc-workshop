# Relay packets

First let's query the balance for Alice and Bob to view how much tokens each have.

In the terminal prompt for each chain run the commands below

### Query balance - Alice

```
chain-a --node tcp://localhost:26657 query bank balances $(chain-a --home $HOME/.chain-a keys --keyring-backend="test" show alice -a)
```

> Please note the amound to `coina` tokens that Alice has. We will check it again later.

### Query balance - Bob

```
chain-b --node tcp://localhost:26557 query bank balances $(chain-b --home $HOME/.chain-b keys --keyring-backend="test" show bob -a)
```

> Please note that Bob only has `coinb` tokens (also some `stake` tokens)

## Fungible token transfer

Now we will transfer some tokens

### Send packet

``` 
hermes -c ./config.toml tx raw ft-transfer chain-a chain-b transfer channel-0 999 1000 -n 1 -d coina | jq
```

### View response

The response has a data field that the information is encoded. To view it, you can use the command below. Just replace `[DATA]` with the value from the `data` field in the response

```
echo "[DATA]" | xxd -r -p | jq
```

### Query packet commitments

```
hermes -c ./config.toml query packet commitments chain-a transfer channel-0 | jq
```

### Query unreceived packets on chain b

```
hermes -c ./config.toml query packet unreceived-packets chain-b chain-a transfer channel-0 | jq
```

### Send recv_packet to chain b

```
hermes -c ./config.toml tx raw packet-recv chain-b chain-a transfer channel-0 | jq
```

### Query unreceived ack on chain a

```
hermes -c ./config.toml query packet unreceived-acks chain-a chain-b transfer channel-0 | jq
```

### Send ack to chain a

```
hermes -c ./config.toml tx raw packet-ack chain-a chain-b transfer channel-0 | jq
```

### Query balance - Alice

To ensure the tokens were transferred, query Alice balance.

```
chain-a --node tcp://localhost:26657 query bank balances $(chain-a --home $HOME/.chain-a keys --keyring-backend="test" show alice -a)
```

### Query balance - Bob

Now we will query Bob's balance to ensure the tokens were transferred.

```
chain-b --node tcp://localhost:26557 query bank balances $(chain-b --home $HOME/.chain-b keys --keyring-backend="test" show bob -a)
```

### View denom trace

In the command above to show the balance, the denom is hashed. In order to view the denom trace you can call the API endpoint below. Just replace the `[denom]` value with the value from the `denom` field (the one that starts with `ibc/`)
```
curl http://localhost:1318/ibc/applications/transfer/v1beta1/denom_traces/[denom]
```

## Send tokens back to chain-a

### Tranfer tokens back

Just replace the `[HASH]` with the hash in the `denom` field

```
hermes -c ./config.toml tx raw ft-transfer chain-b chain-a transfer channel-0 999 1000 -n 1 -d ibc/[HASH] | jq
```

### Send recv_packet to chain b

```
hermes -c ./config.toml tx raw packet-recv chain-a chain-b transfer channel-0 | jq
```

### Send ack to chain b

```
hermes -c ./config.toml tx raw packet-ack chain-b chain-a transfer channel-0 | jq
```

### Query balance - Alice

To ensure the tokens were transferred back, query Alice balance again:

```
chain-a --node tcp://localhost:26657 query bank balances $(chain-a --home $HOME/.chain-a keys --keyring-backend="test" show alice -a)
```

### Query balance - Bob

Query Bob's balance to ensure his token balance for the `ibc/[hash]` denom shows `0` balance

```
chain-b --node tcp://localhost:26557 query bank balances $(chain-b --home $HOME/.chain-b keys --keyring-backend="test" show bob -a)
```