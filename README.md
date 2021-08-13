# Etherium Healthcheck for HAProxy

Etherium healthcheck for HAProxy via Etherium HTTP JSON-RPC API.

## Compiling

You will need go-lang version `1.14` or later to compile the source.

## CLI Options

When starting the tcp server you can specify what address and port it should listen to:

`eth-healthcheck <ip> <port>`

by default it will listen to `127.0.0.1:1301`

## JSON-RPC API

The healthcheck server can check any Etherium client that supports the **JSON-RPC API** via **HTTP**. Here is the documentation for the popular [geth client](https://geth.ethereum.org/docs/rpc/server).

## HAproxy configuration

You will need to tell haproxy to send a message to the tcp server with the HTTP url to a etherium client's JSON-RPC API that you would like to check.

This url should be passed to the `agent-send` parameter in HAproxy config like this:

```
check agent-check agent-addr 127.0.0.1 agent-port 1301 agent-send "http://127.0.0.1:8545\n"
```

Read the [documentation](https://www.haproxy.com/documentation/hapee/latest/load-balancing/health-checking/agent-health-checks) for more information.

## Author

Henrik Hautakoski - [henrik@eossweden.org](mailto:henrik@eossweden.org)
