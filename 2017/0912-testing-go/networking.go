package main

import "net"

// Error checking omitted for brevity
func newConn() (net.Conn, net.Conn) {
	ln, err := net.Listen("tcp", "127.0.0.1:65000")

	var server net.Conn
	go func() {
		defer ln.Close()
		server, err = ln.Accept()
	}()

	client, err := net.Dial("tcp", ln.Addr().String())
	return client, server
}
