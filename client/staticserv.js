'use strict';
var connect = require('connect'),
    http = require('http'),
    ip = require('ip');

module.exports = (function (user) {

  function StaticServer (user) {

    this.ip = ip.address();
    this.port = user.port ? user.port : 3110;

    this.app = connect()
      // .use(connect.logger('dev'))
      .use(connect.static(user.dir.path))
      .use(connect.directory(user.dir.path))
      .use(function(req, res){
        res.end('Hello from Connect!\n');
      });
    
  }

  StaticServer.prototype.connect = function() {
    var self = this;
    http.createServer(this.app).listen(self.port, function() {
      console.log('Sharing on ' + self.ip + ':' + self.port);
    }); 
  };

  return new StaticServer(user);
});
