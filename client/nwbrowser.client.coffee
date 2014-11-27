io = require "socket.io-client"
ss = require "socket.io-stream"
fs = require "fs"
fexists = require 'file-exists'
request = require 'request-json' 
Promise = require("es6-promise").Promise
path  = require("path")

class NetworkBrowser
  constructor : (@mothership, @name) ->

  ##
  # Returns: Promise to the response from ip posting
  post_ip: (token) ->
    self = this
    
    info =
      token : token
      name : @name
      ip : require('ip').address()

    return new Promise (resolve, reject) ->
      client = request.newClient self.mothership
      client.post "/ips", info, (err, res, body) ->
        if err 
          reject err
        if body.status/100 is 4 # Crashes. No status if no mothership.
          reject (new Error(body.status))
        resolve body

  ##
  # Returns: Promise to the ips from the mothership.
  request_ips: () ->
    self = this
    return new Promise (resolve, reject) ->
      client = request.newClient self.mothership
      client.get "/ips", (err, res, body) ->
        if err 
          reject err

        delete body['mexico']
        # delete  body[self.name]
        resolve body

  ##
  # Returns: Promise to the search results on a single ip for a filename query
  search_for_file: (ip, query) -> 
    return new Promise (resolve, reject) ->       
      socket = io.connect "http://#{ip}:3110/", {'force new connection': true, 'secure': true}

      console.log "http://#{ip}:3110/"

      socket.on 'connect_error', (err) ->
        console.log err, "http://#{ip}:3110/"

      socket.on 'error', (err) ->
        console.log 'errored'
        reject err

      socket.on 'reconnect', (n) ->
        console.log "reconnect #{n}"

      socket.on 'reconnect_error', () ->
        console.log 'reconnect_error'

      socket.on 'reconnect_failed', () ->
        console.log 'reconnect_failed'

      socket.on 'connect', () ->
        
        console.log "connected"
        socket.emit 'search_query', query

        socket.on 'search_results', (results) ->
          console.log 'recieved results'
          resolve results.map (x) ->
            ip : ip
            path : x
          socket.disconnect()
        return



      socket.on 'disconnect', () ->
        console.log 'disconnected'
        reject(new Error('disconnected'))

  ##
  # Returns: Promise to the file sucessfully downloaded, raising otherwise
  get_file: (ip, filename) ->

    return new Promise (resolve, reject) ->
      socket = io.connect "http://#{ip}:3110/", {'force new connection': true}
  
      size_file = 0
      prog_file = 0

      console.log "will get file #{filename}"
      
      socket.on "server_log", console.log
  
      socket.on "file_info", (s) -> 
        console.log "got info #{s}"
        size_file = s
  
      fstream = ss.createStream()
  
      fstream.on 'data', (chunk) ->
        prog_file += chunk.length
        console.log 'got %d bytes of data out of %d (%d)', chunk.length
                  , size_file, prog_file/size_file
      
      fstream.on 'error', (err) ->
        reject err
  
      fstream.on 'end', () ->
        resolve 'done.'
        socket.disconnect()
      
      console.log ("to: ./" + path.basename(filename))
      fstream.pipe fs.createWriteStream("./" + path.basename(filename)) #+ ".recieved")
  
      ss(socket).emit "get_file", fstream,
        name: filename

module.exports = NetworkBrowser


##
# Test if main script #
if require.main is module
    nwb = new NetworkBrowser('http://localhost:2800/')
    nwb.request_ips()
    .then(console.log)
    .then () ->
      return nwb.search_for_file('10.147.137.229', 'FRUTA')
    .then (search_results) ->
      return nwb.get_file('10.147.137.229', '/Users/Kevin/Downloads/uTorrent/FRUTA/01 Palmar.m4a')
    .then(console.log)
    .catch(console.trace)

