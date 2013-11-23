express  = require "express"
stylus   = require 'stylus'
io       = require "socket.io"
_        = require 'underscore'
mongoose = require 'mongoose'
http = require("http")
path = require("path")
#mongoose.connect 'mongodb://localhost/cars'
Alphabetoccasion = require './models/alphabetoccasion.js'

glob = {}

app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

#require('./routes/api/alphabetoccasions')(app)

app.get "/", (req, res) ->
  res.render "index"

app.get "/alphabetoccasion", (req,res) ->
  res.render "index"
  alphabetoccasion = require('./lib/parsers/alphabetoccasion')
  alphabetoccasion.search (cars)->

app.get "/search", (req,res) ->
  leaseplan = require('./lib/parsers/scripts/leaseplan')
  leaseplan.search(
    req.param('model')
    req.param('make')
    req.param('fuel')
    req.param('year_from')
    req.param('year_to')
    req.param('mileage')
    req.param('price_from')
    req.param('price_to')
    (cars)->
      res.send(cars)
  )

app.get "/leaseplan", (req,res) ->
  leaseplan = require('./lib/parsers/scripts/leaseplan')
  res.render "index"
  leaseplan.search (cars)->
    console.log(cars)

server = http.createServer(app)

global.socket = io.listen(server)
server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
global.socket.sockets.on 'connection', (socket)->
  global.socket = socket

