request     = require 'request-json' 

class Finder
  constructor: (@name) ->

  search_network: (query) ->
    self = this
    @query ()
      .then (ips) -> 
        
        results = []
        for user, ip of ips
          
          self
            .query_for_files ip 
            .then (files) ->

              # Look for query on the files.
              # If it matches, store file/ip results.
              console.log(files)
        
          

  query_for_files: (ip) -> 
    return new Promise (resolve, reject) -> 
      client = request.newClient 'http://#{ip}:2800/'
      client.get "/files", (err, res, body) ->
        if (err) reject err
        resolve err


  request_ips: ->
    return new Promise (resolve, reject) ->
      client = request.newClient 'http://localhost:2800/'
      client.get "/ips", (err, res, body) ->
        if (err) reject err
        resolve body

  fetch_


module.exports = Finder