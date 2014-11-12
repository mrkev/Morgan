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

      console.log "peer connected"

      
      ##
      # Request: Query object for file to search for.
      # Response: Array of file objects that match query.
      socket.on 'search_query', (query) ->
        io.emit('server_log', "will search for #{query}")
        io.emit('search_results', self.fm.search_paths(new RegExp(query)))
      
    
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
        
        io.emit('server_log', "server will send #{data.name}")
        console.log "Will send", data.name

        # filename = path.basename(data.name)
        filename = data.name
        io.emit('file_info', fs.statSync(filename)["size"])

        fs.createReadStream(filename).pipe stream
        
        io.emit('server_log', "server sending #{data.name}")
    )

  #
  # Listen
  listen: (port) ->
    @http.listen port, () ->
      console.log 'listening on *:3000'
    
  

module.exports = SimpServ



##
# Test if main script #
if require.main is module
    serv = new SimpServ()
    serv.listen 3110
