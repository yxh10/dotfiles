from twisted.internet import reactor, protocol
import json
import signal
import sys


zephConn = None

# json.loads(s)


class EchoClient(protocol.Protocol):
    def connectionMade(self):
        global zephConn
        zephConn = self
        s = json.dumps([0, 0, 'alert', 'hello world', 1])
        self.transport.write(str(len(s)) + '\n' + s)

    def dataReceived(self, data):
        print "Server said:", data
        print zephConn
        # self.transport.loseConnection()

    def connectionLost(self, reason):
        print "connection lost"

class EchoFactory(protocol.ClientFactory):
    protocol = EchoClient

    def clientConnectionFailed(self, connector, reason):
        print "Connection failed - goodbye!"
        # reactor.stop()

    def clientConnectionLost(self, connector, reason):
        print "Connection lost - goodbye!"
        # reactor.stop()

f = EchoFactory()
reactor.connectTCP("localhost", 1235, f)
reactor.run()
