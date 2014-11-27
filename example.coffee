Promise = require("es6-promise").Promise
Client  = require './client/socketio.client.coffee'
config  = require './example_config.coffee'

auth =
  name : config.name
  token : config.token


client = new Client config.share_dir
client.connect_mothership 'http://10.32.196.154:2800/', auth

all_results = []
client.search_network('FRUTA', (results) ->
  console.log 'got > ', results
  all_results = all_results.concat results
).then(() ->
  console.log "#{all_results.length} results total"
).then(() ->
  console.log all_results
  file = all_results[8]
  client.nwb.get_file(file.ip, file.path,
    ((info) -> console.log("file to download:", info)),
    ((prog, sofar, tot) ->
      console.log 'got %d bytes of data out of %d (%d)', sofar, tot, prog*100 >> 0)
  )
).then(console.log)
.catch console.trace