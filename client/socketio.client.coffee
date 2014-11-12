Promise = require("es6-promise").Promise
SimpServ = require "./socketio.simpser.coffee"
FileManager = require "./filemanager.server.coffee"
NetworkBrowser = require "./nwbrowser.client.coffee"

class Client
  constructor : (downloads_dir, mothership) ->
    
    @fm = new FileManager downloads_dir, (fm) ->
      serv = new SimpServ(fm)
      serv.listen 3110

    @nwb = new NetworkBrowser mothership
    @nwb.post_ip()


module.exports = Client


##
# Test if main script #
if require.main is module
    client = new Client '/Users/Kevin/Downloads/uTorrent', 'http://localhost:2800/'  #'http://10.32.196.154:2800/'
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
