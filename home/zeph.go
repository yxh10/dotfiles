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

var respChans = make(map[float64]chan interface{})

func convert(obj interface{}) interface{} {
	if m, ok := obj.(map[string]interface{}); ok {
		return m["_id"]
	}
	return obj
}

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
		respChans[id.(float64)] <- convert(obj)
	}
}






var msgid float64 = 0
func send(recv float64, method string, args ...interface{}) interface{} {
	hasFn := false
	var takesArgs bool
	var f1 func()
	var f2 func(interface{})

	if len(args) > 0 {
		lastarg := args[len(args)-1]
		var isf1, isf2 bool
		f1, isf1 = lastarg.(func())
		f2, isf2 = lastarg.(func(interface{}))
		hasFn = isf1 || isf2
		if hasFn {
			args = args[:len(args) - 1]
			takesArgs = isf2
		}
	}

	msgid++

	ch := make(chan interface{}, 10) // probably enough
	respChans[msgid] = ch

	msg := []interface{}{msgid, recv, method}
	val, _ := json.Marshal(append(msg, args...))
	jsonstr := string(val)
	fmt.Printf("%v\n%v", len(jsonstr), jsonstr)
	fmt.Fprintf(c, "%v\n%v", len(jsonstr), jsonstr)

	if hasFn {
		go func() {
			val := <-ch
			numTimes := val.(float64)
			times := int(numTimes)
			fmt.Println(times)

			blk := func() {
				val := <-ch

				if takesArgs {
					f2(val)
				} else {
					f1()
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




var API float64 = 0


func main() {
	send(API, "bind", "d", []string{"cmd", "shift"}, func() {
		send(API, "alert", "there", 1)

		win := send(API, "focused_window")
		fmt.Printf("win = %#v\n", send(win.(float64), "title"))

		// send(API, "choose_from", []string{"foo", "bar"}, "title", 20, 20, func(i interface{}) {
		// 	fmt.Println("inner!", i)
		// })
	})

	listenForCallbacks()
}
