# get express
express			= require('express')
bodyParser 		= require('body-parser')
session 		= require('express-session')

# create the instance to setup and use
app = express()

# middleware
app.use bodyParser.urlencoded({ extended: true })
app.use bodyParser.json()

# setup our public handler
app.use express.static('public')

# setup the session
app.use session({ 

	secret: process.env.SECRET or '87F90961A0E1ABC05B946D89E07D3C4563' 

})

# set the view engine
app.set 'view engine', 'jade'

# expose interface
module.exports = exports = app