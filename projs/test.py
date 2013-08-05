import socket
import threading
import json
import Queue


ONEYEAR = 365 * 24 * 60 * 60



s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('127.0.0.1', 1235))

q = Queue.Queue(10)

class DataReader:
  def __init__(self):
    self.buf = ''
    self.readingSize = None

  def processData(self):
    if self.readingSize:
      l = len(self.buf)
      if l >= self.readingSize:
        msg, self.buf = self.buf[:l], self.buf[l:]
        obj = json.loads(msg)
        self.readingSize = None
        q.put(obj)
        self.processData()
    else:
      idx = self.buf.find('\n')
      if idx != -1:
        self.readingSize = int(self.buf[:idx])
        self.buf = self.buf[idx+1:]
        self.processData()

  def readForever(self):
    while True:
      self.buf += s.recv(4096)
      self.processData()



class DataWriter:
  def __init__(self):
    self.buf = ''

  def queueData(self):
    pass

  def writeForever(self):
    pass



dw = DataWriter()
t = threading.Thread(target=dw.writeForever)
t.daemon = True
t.start()



dr = DataReader()
t = threading.Thread(target=dr.readForever)
t.daemon = True
t.start()



def sendMessage(msg):
  msgStr = json.dumps(msg)
  s.send(str(len(msgStr)) + '\n' + msgStr)

sendMessage([0, 0, 'bind', 'd', ['cmd', 'shift']])




try:
  while True:
    msg = q.get(True, ONEYEAR)
    print "got msg:", msg
except KeyboardInterrupt:
  print 'k bye'
