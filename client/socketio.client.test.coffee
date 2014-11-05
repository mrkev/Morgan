# The peer

io = require "socket.io-client"
ss = require "socket.io-stream"
fs = require "fs"

get_file = (name, addr) ->
  socket = io.connect addr
  socket.on "server_log", (msg) -> 
    console.log msg

  size = 0
  tot  = 0
  socket.on "file_info", (s) -> 
    size = s

  stream = ss.createStream()

  stream.on 'data', (chunk) ->
    tot += chunk.length
    console.log 'got %d bytes of data out of %d (%d)', chunk.length, size, tot/size
  
  stream.on 'error', (err) ->
    console.log err 

  stream.on 'end', () ->
    console.log 'there will be no more data.'
  

  filename = name
  ss(socket).emit "get_file", stream,
    name: filename

  stream.pipe fs.createWriteStream(filename + ".recieved")

get_file "vid.mp4", "http://localhost:3110/"


### Unimplemented: For uploading (peer -> server)

# post_file = () ->
#   socket = io.connect "http://localhost:3110/"
#   stream = ss.createStream()
#   filename = "info.txt"
#   ss(socket).emit "from_peer", stream,
#     name: filename
# 
#   fs.createReadStream(filename).pipe stream## 

###