connect = require 'connect'
http = require 'http'
ip = require 'ip'

#
# Static server.
#

module.exports = ((preferences) ->
  
  StaticServer = (preferences) ->
    @ip   = ip.address()
    @port = if preferences.port then preferences.port else 3110
    
    @app = connect()
    # .use(connect.logger('dev'))
      .use(connect.static(preferences.directory.path))
      .use(connect.directory(preferences.directory.path))
      .use((req, res) ->
        res.end "Hello from Connect! Though you shouldn't be seeing this... Hmmm /:\n"
        return
      )
    return


  StaticServer::connect = ->
    self = this
    http.createServer(@app).listen self.port, ->
      console.log "Sharing on " + self.ip + ":" + self.port
      
      
  new StaticServer(preferences)
)