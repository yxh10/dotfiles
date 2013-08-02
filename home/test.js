var net = require("net");

var connection = net.connect(1235, "localhost", function() {
                   console.log("client connected");
                   connection.write("33\n" + '[0, 0, "alert", "hello world", 2]');
                 });
