'use strict';
var connect = require('connect'),
    http = require('http'),
    ip = require('ip');

module.exports = (function (preferences) {

  function StaticServer (preferences) {

    this.ip = ip.address();
    this.port = preferences.port ? preferences.port : 3110;

    this.app = connect()
      // .use(connect.logger('dev'))
      .use(connect.static(preferences.directories[0]))
      .use(connect.directory(preferences.directories[0]))
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

  return new StaticServer(preferences);
});
