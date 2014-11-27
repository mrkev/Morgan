###
#     Sets up a Socket.io server.
###
fs = require "fs"
class SimpServ
  
  constructor: (@fm) -> 
    app   = require('express')()
    @http = require('http').Server(app)
    io    = require('socket.io')(@http)
    ss    = require("socket.io-stream")
    path  = require("path")
    self  = this

    #
    # Set up HTTP server
    app.get '/', (req, res) ->
      res.sendfile 'info.txt'
    
    #
    # Set up Socket.IO server
    io.on('connection', (socket) ->
      console.log "S-: Peer connected"

      socket.on 'error', (err) ->
        console.log 'S-: errored'

      
      ##
      # Request: Query object for file to search for.
      # Response: Array of file objects that match query.
      socket.on 'search_query', (query) ->
        socket.emit('server_log', "S+: Will search for #{query}")
        socket.emit('search_results', self.fm.search_paths(new RegExp(query)))
        socket.disconnect();
      
    
      ## Unimplemented: (peer -> server) upload
      #ss(socket).on "post_file", (stream, data) ->
      #  io.emit('server_log', "server will recieve #{data.name}")
      #  filename = path.basename(data.name + '.yo')
      #  stream.pipe fs.createWriteStream(filename)
      #  io.emit('server_log', "server getting #{data.name}")

      ##
      # Send data to a client
      # Request:  [stream] stream to use
      #           [data] file object { name, hash }
      # Response: File data for requested file.
      #           Error if file can't be sent.
      
      ss(socket).on "get_file", (stream, data) ->
        socket.emit('server_log', "S+: Server will send #{data.name}")
        console.log "S-: Will send", data.name

        # filename = path.basename(data.name)
        filename = data.name
        socket.emit('file_info', fs.statSync(filename)["size"])

        fs.createReadStream(filename).pipe stream
        
        socket.emit('server_log', "S+: Server sending #{data.name}")

        return

      socket.on 'disconnect', () ->
        console.log('S-: Peer disconnected')
    )

  #
  # Listen
  listen: (port) ->
    @http.listen port, () ->
      console.log 'S-: listening on *:3000'
    
  

module.exports = SimpServ



##
# Test if main script #
if require.main is module
    serv = new SimpServ()
    serv.listen 3110
