#                                                                              #
#                              Morgan server                                   #
#                                                                              #

express    = require 'express'
bodyParser = require 'body-parser' 
config     = require './config'
app        = express()
router     = express.Router()

ipdb    = { 'mexico' : '127.0.0.1' }
tokendb =
  'mexico' : '2ojlkfsj09203nasdfkj'
  'mrjamj' : 'KJDSFL:SDOIFNOSDFIKJDSFJOSD'

#
# Set up the routes
#

## Home
router
  .route('/')
  .get (req, res) ->
    res.sendFile __dirname + '/info.txt'
    return

## Get the ips
router
  .route('/ips')
  .get (req, res) -> 
    res.json(ipdb)


## Post an IP
router
  .route('/ips')
  .post (req, res) ->
    if tokendb[req.body.name] is req.body.token
      ipdb[req.body.name] = req.body.ip 
      res.json({status : 200})
      console.log ipdb
    else 
      console.log 'Wrong token.'
      res.json({status : 401})


#
# Start the server
app
  .use bodyParser.json()
  .use (error, req, res, next) ->
    # Error parsing. Just log it. 
    console.log error
  .use('/', router)
  .listen(config.port, config.ipaddr)

console.log('Good stuff happens on port ' + config.port)

# { 
#     "user" : "user1", 
#     "ip" : "21.34.65.234",
#     "token" : "2ojlkfsj09203nasdfkj"
# } 

