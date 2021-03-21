# Starport Chains

For this workshop, we will be using two pre-configured Starport chains. These chains were created with the latest Starport version v0.15 which supports IBC. There are two chains, `chain-a` and `chain-b`.

These steps assume you follow the [setup](./setup.md) first.

## Running the chains

Follow this instructions to run the two chains

### -------------------------------
### CHAIN-A
### -------------------------------

### Configure and run chain-a

Open a terminal prompt in the workshop folder location. Move into the chain-a directory:

```
cd ./chains/chain-a
```

### Build chain-a

This command builds the executable `chain-a`

```
starport build
```

### Restore key (Alice)

This command restores a key for a user in `chain-a` that we will be using during the workshop.

```
chain-a keys add alice --recover --home $HOME/.chain-a
```

When prompted for the mnemonic please enter the following words:

```
oxygen soap solid wave swim dumb piece pass bronze horn bronze sweet acid radio reform clump team behind deer anxiety volcano reform jewel inspire
```

### Start chain-a

In order to start the chain-a run the starport command below:

```
starport serve -c config.yml
```
 
### Query Alice's balance

Open another terminal prompt in the same location (chain-a folder) and run the command below to check Alice's balance:

```
chain-a --node tcp://localhost:26657 query bank balances $(chain-a --home $HOME/.chain-a keys --keyring-backend="test" show alice -a)
```

### -------------------------------
### CHAIN-B
### -------------------------------

### Configure and run chain-b

Open a terminal prompt in the workshop folder location. Move into the chain-b directory:

```
cd ./chains/chain-b
```

### Build chain-b

This command builds the executable `chain-b`

```
starport build
```

### Restore key (Bob)

This command restores a key for a user in `chain-b` that we will be using during the workshop.

```
chain-b keys add bob --recover --home $HOME/.chain-b
```

When prompted for the mnemonic please enter the following words:

```
become observe excess guitar wreck planet treat artist oblige depart fix deposit uphold drift sick amount agree frame pilot transfer nerve guitar section tail
```

### Start chain-b

In order to start the chain-b run the starport command below:

```
starport serve -c config.yml
```
 
# Query Bob's balance

Open another terminal prompt in the same location (chain-b folder) and run the command below to check Bob's balance:

```
chain-b --node tcp://localhost:26557 query bank balances $(chain-b --home $HOME/.chain-b keys --keyring-backend="test" show bob -a)
```
