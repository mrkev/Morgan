#                                                                              #
#                              Morgan client                                   #
#                                                                              #
require 'coffee-script/register'

request     = require 'request-json' 
ip          = require 'ip'
http        = require 'http'
filed       = require 'filed'
os          = require 'os'
Crawler     = require "./dir"
select      = require 'jsonselect'
ui          = require './ui-cli'
preferences = require './preferences'
randtoken   = require 'rand-token'
Promise     = require('es6-promise').Promise

#
# Load the user
#

chain = 

  ## First, make sure we have the stuff we need
  new Promise (resolve) ->
    
          # Create a user
    if preferences.user is undefined
        ui
          # Get a user name
          .createUser()

          # Give the user a token
          .then (user) ->
            user.token = randtoken.generate 16
            return { user : user }

          # Get a direcotry
          .then (pref) -> 
            return ui

            .askForDirectory()
            
            .then (directory) ->
              pref.directory = directory
              return pref

          # Save it
          .then (pref) ->
            preferences.load pref
            return preferences

          .then(resolve)

    else resolve(preferences)


## Next, boot up this madness
chain

    # Start up the server
    .then (preferences) ->
        sv = require("./staticserv")(preferences)
        sv.connect()
    
    # Post our IP
    .then -> 
        client = request.newClient 'http://localhost:2800/'
        client.post "/ips", select(user, {only: '.name .token .ip'}) , (err, res, body) ->
          console.log res.body
          ui = new ui(user, sv)
          ui.start()





#
# Set up the Server
#

# fc = new Crawler(user)
# fc.crawl()
#     .then (files) ->
# 





