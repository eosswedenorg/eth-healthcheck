module eosswedenorg/eth-healthcheck

go 1.14

require (
	github.com/go-stack/stack v1.8.0
	github.com/inconshreveable/log15 v0.0.0-20201112154412-8562bdadbbac
	github.com/mattn/go-colorable v0.1.8
	github.com/mattn/go-isatty v0.0.13
	github.com/onrik/ethrpc v1.0.0
	github.com/pborman/getopt/v2 v2.1.0
	internal/haproxy v1.0.0
	internal/tcp_server v1.0.0
)

replace internal/haproxy => ./src/haproxy
replace internal/tcp_server => ./src/tcp_server
