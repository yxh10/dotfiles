import socket
import threading
import json
import Queue


ONEYEAR = 365 * 24 * 60 * 60



s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('127.0.0.1', 1235))

q = Queue.Queue(10)

def whatever():
    while True:
        data = s.recv(4096)
        q.put(data)



t = threading.Thread(target=whatever)
t.daemon = True
t.start()



msg = [0, 0, 'alert', 'hello world', 2]
msgStr = json.dumps(msg)
s.send(str(len(msgStr)) + '\n' + msgStr)




try:
    while True:
        data = q.get(True, ONEYEAR)
        print "received data:", data
except KeyboardInterrupt:
    print 'k bye'
