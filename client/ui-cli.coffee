keypress = require 'keypress'
inquirer = require 'inquirer'
Promise  = require('es6-promise').Promise


module.exports = ((user, serv) ->
  
  UI = ->
    @hi = 4
    
  UI::start = ->
    # Start catching keypresses
    keypress(process.stdin)
    process.stdin.on('keypress', manage_keys)
    textmode false

   
  UI.createUser = ->

    console.log 'You\'ll need a username.'

    authQuestions = [{
        type: 'input'
        name: 'name'
        message: 'username:'
    }];

    return new Promise (resolve) ->
        inquirer.prompt authQuestions, (user) ->
            if user.name isnt ''
              resolve(user);
            
            else
              console.log 'Alright, you can still opt-in later if you want.'
              action_close()


  return UI
)()

manage_keys = (ch, key) ->
  
  # Were inputting text, so don't do anything else.
  return if text
  
  # Next news feed item
  if key?.name is "space"
    console.log 'WHATUP'
    return

  if key?.ctrl and key?.name is 'c'
    console.log('yo')
    action_close()
    return

action_close = () ->
  process.stdin.pause()
  process.exit(0)




text = false
###
Toggles textmode, so we can input strings of characters
@param [bool] tm - Whether to enter (true) or exit (false) textmode
###
textmode = (tm) ->
  if tm
    process.stdin.setRawMode false
    text = true
  else
    process.stdin.setRawMode true
    text = false
    process.stdin.resume()
  return