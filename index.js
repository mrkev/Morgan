var http = require('http'),
    filed = require('filed'),
    ip = require('ip'),
    os = require('os');

var downloads = os.platform === 'darwin' ? '~/Downloads' : "./public"

server = http.createServer(function(req, resp) {
  console.log('req for' + req.url);
  if (req.url === "/") {
    req.pipe(filed('./public/index.html')).pipe(resp);
  } else {
    req.pipe(filed("./public" + req.url)).pipe(resp);
  }
});

var port = process.argv[2] || 8080

server.listen(port, function() {
  console.log("Sharing on " + ip.address() + ":" + port);
}); 


// 10.145.133.56
