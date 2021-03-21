# Hermes IBC Workshop

## Introduction

In this workshop we will be working with the [Hermes IBC Relayer](https://hermes.informal.systems) in order to transfer fungible tokens ([ics-020](https://github.com/cosmos/ics/tree/master/spec/ics-020-fungible-token-transfer)) between two [Starport](https://github.com/tendermint/starport) custom [Cosmos SDK](https://github.com/cosmos/cosmos-sdk) chains.

This repository contains all the instructions if you want to run the workshop in your local computer. Please follow the step-by-step instructions below to complete the workshop.

This workshop's primary goal is to better understand the IBC protocol and how packets are relayed from one chain to another using the IBC primitives (client, connections, channels, ports, and packets).

This workshop will be presented at the [HackAtom RU](https://hackatom-ru.devpost.com/) by [Andy Nogueira](https://github.com/andynog) from [Informal Systems](https://informal.systems).

## Step-by-step Instructions

Please follow these instructions to complete the workshop:

1. [Setup Environment](./docs/setup.md)
2. [Run chains](./docs/chains.md)
3. [Configure clients](./docs/clients.md)
4. [Connection Handshake](./docs/connection.md)
5. [Channel Handshake](./docs/channel_handshake.md)
6. [Relay Packets (Transfer Tokens)](./docs/relay.md) 

## References

*  [Interchain Standards](https://github.com/cosmos/ics)
* [IBC Protocol Website](https://ibcprotocol.org)
* [IBC Modules and Relayer in Rust](https://github.com/informalsystems/ibc-rs)
* [Hermes Documentation](https://hermes.informal.systems)
