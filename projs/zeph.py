from twisted.internet import reactor, protocol
import json

# zephConn = None



ONEYEAR = 365 * 24 * 60 * 60

class EchoClient(protocol.Protocol):
    def connectionMade(self):
        # global zephConn
        # zephConn = self

        self.buf = ''
        self.readingSize = None

        self.sendMsg([0, 0, 'bind', 'd', ['cmd', 'shift']])

    def sendMsg(self, msg):
        msgStr = json.dumps(msg)
        self.transport.write(str(len(msgStr)) + '\n' + msgStr)

    def dataReceived(self, data):
        self.buf += data
        while self.processIncomingData():
            pass

    def handleMessage(self, msg):
        print 'msg:', msg

    def processIncomingData(self):
        if self.readingSize:
            l = len(self.buf)
            if l >= self.readingSize:
                msg, self.buf = self.buf[:l], self.buf[l:]
                obj = json.loads(msg)
                self.handleMessage(obj)
                self.readingSize = None
                return True
        else:
            idx = self.buf.find('\n')
            if idx != -1:
                self.readingSize, self.buf = int(self.buf[:idx]), self.buf[idx+1:]
                return True

        return False

class EchoFactory(protocol.ClientFactory):
    protocol = EchoClient

f = EchoFactory()
reactor.connectTCP("localhost", 1235, f)
reactor.run()
