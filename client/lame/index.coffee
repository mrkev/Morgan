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
ip          = require 'ip'

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

              pref.directories = [directory]
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
        console.log 'asdf'
        sv = require("./staticserv")(preferences)
        sv.connect()
        console.log(preferences)
    
    # Post our IP
    .then (preferences) -> 
        usr = select(preferences.user, {only: '.name .token .ip'})
        usr.ip = ip.address()
        client = request.newClient 'http://localhost:2800/'
        client.post "/ips", usr , (err, res, body) ->
          console.log res.body
          ui = new ui(preferences, sv)
          ui.start()

    .catch console.trace




#
# Set up the Server
#

# fc = new Crawler(user)
# fc.crawl()
#     .then (files) ->
# 





