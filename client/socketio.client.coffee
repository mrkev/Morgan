Promise = require("es6-promise").Promise
SimpServ = require "./socketio.simpser.coffee"
FileManager = require "./filemanager.server.coffee"
NetworkBrowser = require "./nwbrowser.client.coffee"

class Client
  constructor : ->
    
    @fm = new FileManager '/Users/Kevin/Downloads/uTorrent', (fm) ->
      serv = new SimpServ(fm)
      serv.listen 3110

    @nwb = new NetworkBrowser 'http://10.32.196.154:2800/'
    @nwb.post_ip()


if require.main is module
    client = new Client()
    
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