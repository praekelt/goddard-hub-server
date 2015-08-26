
# get express
express			= require('express')
bodyParser 		= require('body-parser')
session 		= require('express-session')
raven 			= require('raven');
RedisStore 		= require('connect-redis')(session);

# create the instance to setup and use
app = express()

# Should be the first item listed
app.use(raven.middleware.express.requestHandler(process.env.SENTRY_DSN or ''))

# middleware
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })

# setup our public handler
app.use express.static('public')

# session params
session_params = { 
	
	resave: true,
	saveUninitialized: true,
	secret: process.env.SECRET or '87F90961A0E1ABC05B946D89E07D3C4563' 

}

# if production use redis
if process.env.NODE_ENV != 'testing'

	# set to redis !
	session_params.store = new RedisStore({})

# setup the session
app.use session(session_params)

# set the view engine
app.set 'view engine', 'jade'

# Should come before any other error middleware
app.use(raven.middleware.express.errorHandler(process.env.SENTRY_DSN or ''))

# expose interface
module.exports = exports = app