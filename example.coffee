Promise = require("es6-promise").Promise
Client  = require './client/socketio.client.coffee'

try 
  config = require './example_config.coffee'
catch e
  config = 
    share_dir : __dirname


client = new Client config.share_dir, 'http://10.32.196.154:2800/'  #'http://10.32.196.154:2800/'

all_results = []
client.search_network('FRUTA', (results) ->
  console.log 'got > ', results
  all_results = all_results.concat results
).then () ->
  console.log 'all results:'
  console.log all_results
.catch console.trace