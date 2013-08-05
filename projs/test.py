import socket
import threading
import json
import Queue
import sys



_old_excepthook = sys.excepthook
def myexcepthook(exctype, value, traceback):
    if exctype == KeyboardInterrupt:
        pass
    else:
        _old_excepthook(exctype, value, traceback)
sys.excepthook = myexcepthook






s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('127.0.0.1', 1235))

rawMessageQueue = Queue.Queue(10)

def msgIdGen():
  i = 0
  while True:
    i += 1
    yield i

reifiedMsgIdGen = msgIdGen()


def runInBackground(fn):
  t = threading.Thread(target=fn)
  t.daemon = True
  t.start()



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
        rawMessageQueue.put(obj)
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


runInBackground(DataReader().readForever)



sendDataQueue = Queue.Queue(10)

def sendDataFully():
  while True:
    data = sendDataQueue.get()
    while len(data) > 0:
      numWrote = s.send(data)
      data = data[numWrote:]




runInBackground(sendDataFully)



individualMessageQueues = {}


def sendMessage(msg):
  msgId = reifiedMsgIdGen.next()
  tempSendQueue = Queue.Queue(10)
  individualMessageQueues[msgId] = tempSendQueue

  msg.insert(0, msgId)
  msgStr = json.dumps(msg)
  sendDataQueue.put(str(len(msgStr)) + '\n' + msgStr)

  retVal = tempSendQueue.get()
  return retVal


def dispatchIndividualMessagesForever():
  while True:
    msg = rawMessageQueue.get()

    msgId = msg[0]
    thisQueue = individualMessageQueues[msgId]
    thisQueue.put(msg)

    print "got msg:", msg

    if msgId == 1:
      def tempFn():
        print sendMessage([0, 'alert', 'stuff', 1])
      runInBackground(tempFn)



runInBackground(dispatchIndividualMessagesForever)




a = sendMessage([0, 'bind', 'd', ['cmd', 'shift']])
print 'hahaha', a




while True:
  pass
