request = require 'request'
cheerio = require 'cheerio'
async   = require 'async'
_       = require 'underscore'

leaseplan =
  search: (f_model,f_make,f_fuel,f_year_of,f_year_to,f_mileage,f_price_of,f_price_to,callback)->
    cars = []
    urls = []
    if f_model
      if f_model.toLowerCase() == 'citroen' then f_model = 'Citroën'
      if f_model.toLowerCase() == 'skoda' then f_model = 'Škoda'
    $ = cheerio.load(body)
    $(this).find('.carResult').each ()->
      info = $(this).find('.infoCol_3')
      make_model = $(this).find('.listHead').text().split('-')
      make = make_model[0].trim()
      model = make_model[1].trim()
      price = $(info).find('b:first').text().split(' ')[1].replace(',','.').trim()
      year = $(info).find('>font:first').text().trim()
      mileage = $(info).find('>font').eq(1).text().replace('km.','').trim()
      fuel = $(info).find('>font').eq(2).text().trim()

      cars.push
        make_model: make_model
        make: make
        model: model
        price: price
        year: year
        mileage: mileage
        fuel: fuel
    callback(cars)

module.exports = leaseplan