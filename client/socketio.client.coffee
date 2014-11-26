Promise = require("es6-promise").Promise
SimpServ = require "./socketio.simpser.coffee"
FileManager = require "./filemanager.server.coffee"
NetworkBrowser = require "./nwbrowser.client.coffee"

###
status = 0 : disconnected, 1 : listening, 3 : ip posted
###

class Client
  constructor : (downloads_dir) ->
    @status = 0

    self = this
    @fm = new FileManager downloads_dir, (fm) ->
      serv = new SimpServ(fm)
      serv.listen 3110
      self.status = 1

  ##
  # Connects to a mothership
  connect_mothership : (mothership, auth) ->
    @nwb = new NetworkBrowser mothership, auth.name
    @nwb
      .post_ip(auth.token)
      .catch (err) ->
        console.log 'Couldn\'t post IP. Correct token?'
      .then (header) ->
        self.status += 2

  ##
  # Searches entire network with [query].
  # @param  [query] to search.
  # @param  [callback] to be called when new results are available.
  # @return Promise to undefined on search complete.
  search_network : (query, callback) ->
    self = this
    @nwb.request_ips()
    .then (ips) ->
      chain = Promise.resolve()
      acc   = []
      
      for own user, ip of ips        
        chain = chain.then(() ->
          console.log ">: Now searching", user, ip # Crashes if no mothership
          return self.nwb
            .search_for_file(ip, query) # Hangs if unavailable ip
            .then callback
        )

      return chain

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
          console.log "searching", ip # Crashes if no mothership
          return client.nwb
          .search_for_file(ip, 'FRUTA') # Hangs if unavailable ip
          .then (search_results) ->
            console.log "sr", search_results
            acc.concat(search_results)
        )

      return chain.catch(console.trace)

    .then(console.log)
    .catch(console.trace)
