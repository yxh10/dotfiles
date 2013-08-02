package main

import "fmt"
import "net"
import "bufio"
import "encoding/json"

func connect() net.Conn {
	conn, _ := net.Dial("tcp", "localhost:1235")
	return conn
}

var c net.Conn = connect()
var msgid = 0



var API uint64 = 0


func send(recv uint64, method string, args ...interface{}) interface{} {
	msgid++
	msg := []interface{}{msgid, recv, method}
	val, _ := json.Marshal(append(msg, args...))
	jsonstr := string(val)
	fmt.Fprintf(c, "%v\n%v", len(jsonstr), jsonstr)
	return 3
}

func main() {
	send(API, "alert", "hi", 3)

	status, _ := bufio.NewReader(c).ReadString('\n')
	fmt.Println("its %v", status)
}
