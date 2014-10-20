#                                                                              #
#                              Morgan server                                   #
#                                                                              #
express = require('express')
bodyParser = require 'body-parser' 
app     = express()
router  = express.Router()

config  = require './config'


ipdb = { 'user1' : '0.0.0.0' }

tokendb = {
  'user1' : '2ojlkfsj09203nasdfkj'
}

# { 
#     "user" : "user1", 
#     "ip" : "21.34.65.234",
#     "token" : "2ojlkfsj09203nasdfkj"
# } 

#
# Set up the routes
#

## Home

router
  .route('/')
  .get (req, res) ->
    res.sendFile __dirname + '/info.txt'
    return

## Roster@Katara
router
  .route('/ips')
  .get (req, res) -> 
    res.json(ipdb)


router
  .route('/ips')
  .post (req, res) ->
    console.log(req.body);

    if tokendb[req.body.name] is req.body.token
      ipdb[req.body.name] = req.body.ip 
    else 
      console.log 'Wrong token.'

    res.json({status : 200})

#
# Start the server
#
app
  .use bodyParser.json()
  .use (error, req, res, next) ->
    # Error parsing. Just log it. 
    console.log error
  .use('/', router)
  .listen(config.port, config.ipaddr)

console.log('Good stuff happens on port ' + config.port)