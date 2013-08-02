var net = require("net");

var client = net.connect(1235, function() {
               var obj = [0, 0, "alert", "hello world", 2];
               var str = JSON.stringify(obj);
               client.write(str.length + "\n" + str);
             });

client.on('data', function(data) {
  console.log(data.toString());
});
