package main

import "io"

func main() {
	_, s := newConn() // Returns net.Conn interface
	Echo(s)
}

func Echo(c io.ReadWriteCloser) error {
	buf := make([]byte, 2<<10)

	n, _ := c.Read(buf)

	c.Write(buf[:n])

	return c.Close()
}
