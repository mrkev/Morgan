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
).then () ->
  console.log 'all results:'
  console.log all_results
.catch console.trace