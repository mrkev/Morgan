Promise = require("es6-promise").Promise
Client  = require './client/socketio.client.coffee'

try 
  config = require './example_config.coffee'
catch e
  config = 
    share_dir : __dirname


client = new Client config.share_dir, 'http://10.32.196.154:2800/'  #'http://10.32.196.154:2800/'
client.nwb.request_ips()
.then (ips) ->
  return new Promise (resolve) ->
    setTimeout () ->
      resolve(ips)
    , 5000

.then (ips) ->
  chain = Promise.resolve()
  acc   = []
  
  for own user, ip of ips
    console.log ">:", user, ip
    
    chain = chain.then(() ->
      console.log "searching", ip
      return client.nwb
      .search_for_file(ip, 'FRUTA') # Hangs if unavailable ip
      .then (search_results) ->
        console.log "sr", search_results
        acc.concat(search_results)
    )

  return chain.catch(console.trace)

.then(console.log)
.catch(console.trace)