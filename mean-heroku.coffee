# Clue 42  Backend

# modules
express         = require('express')
session         = require('express-session')
app             = express()
mongoose        = require('mongoose')
morgan          = require('morgan')
fs              = require('fs')
log4js          = require('log4js')



logger = log4js.getLogger('app')

mongoose.connect(process.env.MONGODB_URL)

db = mongoose.connection
db.on 'error', (err) ->
  logger.error "Error connecting to datatbase"
  logger.error err
db.on 'connected', () ->
  logger.debug 'Connected to database'
db.once 'open', callback = ->
  logger.debug 'Connection to database established and database open'

port = process.env.PORT || 8080

app.use(express.static(__dirname + '/_public'))

#
# Logging
#

accessLogStream = fs.createWriteStream(__dirname + '/access.log', {flags: 'a'})
logger.debug "Writing access log to #{__dirname + '/access.log'}"
app.use(morgan('combined', {stream: accessLogStream}))

logger.debug 'App listening on port', port
app.listen(port)
logger.debug 'App started on port', port

module.exports = app
