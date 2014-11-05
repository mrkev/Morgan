Promise = require("es6-promise").Promise
SimpServ = require "./socketio.simpser.coffee"
FileManager = require "./filemanager.server.coffee"
NetworkBrowser = require "./nwbrowser.client.coffee"

class Client
  constructor : ->
    
    fm = new FileManager '/Users/Kevin/Downloads/uTorrent', (fm) ->
      console.log(fm.search_paths /Color/)
    
      serv = new SimpServ(fm)
      serv.listen 3110

    nwb = new NetworkBrowser('http://localhost:2800/')
    nwb.post_ip()
    .then () ->
      return nwb.request_ips()
    
    .then (ips) ->
      chain = Promise.resolve()
      acc  = []
      for own user, ip of ips
        console.log user, ip
        chain = chain.then () ->
          return Promise.resolve('hi')
        #  return nwb.search_for_file ip /Color/
        .then (search_results) ->
          acc.push(search_results)

      return chain.catch(console.trace).then () -> return acc

    .then(console.log)
    .catch(console.trace)



if require.main is module
    client = new Client()

