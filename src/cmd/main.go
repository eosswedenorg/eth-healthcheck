
package main

import (
    "fmt"
    "strings"
    log "github.com/inconshreveable/log15"
    "github.com/pborman/getopt/v2"
    "github.com/onrik/ethrpc"
    "github.com/eosswedenorg-go/haproxy"
    "github.com/eosswedenorg-go/tcp_server"
)

var logger log.Logger

func onConnect(c *tcp_server.Client) {
    logger.Info("Client connected", "addr", c.Addr.String())
}

func onTcpMessage(c *tcp_server.Client, message string) {

    status := haproxy.HealthCheckDown
    client := ethrpc.New(strings.TrimSpace(message))

    resp, err := client.EthSyncing()
    if err == nil {
        if resp.IsSyncing == false {
            status = haproxy.HealthCheckUp
        }
    } else {
        logger.Warn(err.Error())
    }

    logger.Info("Node status", "status", status)

    // Report status to HAproxy
    c.WriteString(fmt.Sprintln(status))
    c.Close()
}

func onDisconnect(c *tcp_server.Client, err error) {
    if err == nil {
        logger.Info("Client disconnected", "addr", c.Addr.String())
    } else {
        logger.Warn("Client disconnected", "addr", c.Addr.String(), "err", err)
    }
}

func argv_listen_addr() string {

    var addr string

    argv := getopt.Args()
    if len(argv) > 0 {
        addr = argv[0]
    } else {
        addr = "127.0.0.1"
    }

    addr += ":"
    if len(argv) > 1 {
        addr += argv[1]
    } else {
        addr += "1301"
    }

    return addr
}

func main() {

    var printVersion bool;
    var printUsage bool;

    getopt.SetParameters("[ip] [port]")
    getopt.FlagLong(&printUsage, "help", 'h', "Print this help text")
    getopt.FlagLong(&printVersion, "version", 'v', "Print version")

    getopt.Parse()

    if printUsage {
        getopt.Usage()
        return
    }

    if printVersion {
        print("Version: v0.1.0\n")
        return
    }

    logger = log.New()

    addr := argv_listen_addr()
    server := tcp_server.New(argv_listen_addr())

    logger.Info(fmt.Sprintf("Listening on: %s", addr))

    // TCP Client sends message.
    server.OnConnect(onConnect)
    server.OnMessage(onTcpMessage)
    server.OnDisconnect(onDisconnect)

    err := server.Listen()

    if err != nil {
        logger.Error(err.Error())
    }
}
