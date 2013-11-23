module.exports = (app)->
  app.get "/api/alphabetoccasions", (req, res) ->
    alphabetoccasion = require('../../lib/parsers/alphabetoccasion')
    alphabetoccasion.search null, (cars)->
      ##save to db
      #    _.each cars, (car)->
      #      c = new Alphabetoccasion car
      #      c.save (err,data)->
      #        throw err if err
      res.send JSON.stringify cars
