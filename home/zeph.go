package main

import (
	"fmt"
	"net"
	"bufio"
	"encoding/json"
	"strconv"
	"strings"
	"io"
)

func connect() net.Conn {
	conn, _ := net.Dial("tcp", "localhost:1235")
	return conn
}

var c net.Conn = connect()

var respChans = make(map[uint64]chan interface{})

func listenForCallbacks() {
	reader := bufio.NewReader(c)
	for {
		numBytes, _ := reader.ReadString('\n')
		numBytes = strings.Trim(numBytes, "\n")
		i, _ := strconv.ParseUint(numBytes, 10, 64)

		buf := make([]byte, i)
		io.ReadFull(reader, buf)

		var msg []interface{}
		json.Unmarshal(buf, &msg)

		id, obj := msg[0], msg[1]
		id2 := id.(float64)

		fmt.Printf("id = %v\n", id)
		fmt.Printf("msg = %#v\n", obj)

		respChans[uint64(id2)] <- obj
	}
}






var msgid uint64 = 0
func send(recv uint64, method string, args ...interface{}) interface{} {
	msgid++

	ch := make(chan interface{}, 10) // probably enough

	respChans[msgid] = ch

	msg := []interface{}{msgid, recv, method}
	val, _ := json.Marshal(append(msg, args...))
	jsonstr := string(val)
	fmt.Fprintf(c, "%v\n%v", len(jsonstr), jsonstr)

	resp := <-ch
	fmt.Println(resp)
	return resp

	return 3
}




var API uint64 = 0


func main() {
	send(API, "clipboard_contents")
	listenForCallbacks()
}
