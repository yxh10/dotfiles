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
		// fmt.Println("about to read")

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
	lastarg := args[len(args)-1]

	f1, isf1 := lastarg.(func())
	f2, isf2 := lastarg.(func(interface{}))

	f1 = f1
	f2 = f2

	if isf1 || isf2 {
		args = args[:len(args) - 1]
	}

	// fmt.Println("uhh", isf1, isf2)
	// fmt.Println("args", args)


	msgid++

	ch := make(chan interface{}, 10) // probably enough
	respChans[msgid] = ch

	msg := []interface{}{msgid, recv, method}
	val, _ := json.Marshal(append(msg, args...))
	jsonstr := string(val)
	fmt.Printf("%v\n%v", len(jsonstr), jsonstr)
	fmt.Fprintf(c, "%v\n%v", len(jsonstr), jsonstr)

	if isf1 || isf2 {
		go func() {
			val := <-ch
			numTimes := val.(float64)
			times := int(numTimes)
			fmt.Println(times)

			blk := func() {
				val := <-ch

				switch {
				case isf1:
					f1()
				case isf2:
					f2(val)
				}
			}

			if numTimes > 0 {
				for i :=0; i<times; i++ { blk() }
			} else {
				for { blk() }
			}
			fmt.Println("exiting goroutine")
		}()
		fmt.Println("ONE")
		return nil
	}

	fmt.Println("TWO")
	resp := <-ch
	delete(respChans, msgid)
	return resp
}




var API uint64 = 0


func main() {
	// go func() {
		send(API, "bind", "d", []string{"cmd", "shift"}, func() {
			send(API, "alert", "there", 1)

			send(API, "choose_from", []string{"foo", "bar"}, "title", 20, 20, func(i interface{}) {
				fmt.Println("inner!", i)
			})

			fmt.Println("called!")
		})
	// }()

	// go func() {
		// contents := send(API, "alert", "hi", 1)
		// send(API, "alert", "there", 1)
		// fmt.Println(contents)
	// }()
	listenForCallbacks()
}
