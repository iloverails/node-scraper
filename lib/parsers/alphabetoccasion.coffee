request = require 'request'
cheerio = require 'cheerio'
async   = require 'async'
_       = require 'underscore'

alphabetoccasion =
  search: (callback)->
    main_url = 'http://www.alphabetoccasions.nl/'
    base_url = main_url+'web/site/default.aspx?l=UCC&m=aanbod&a=list'
    detail_url = main_url+'web/site/default.aspx?m=aanbod&a=detail&kenteken='
    cars = []
    urls = []
    request base_url, (err,resp, body)->
      throw err if err
      $ = cheerio.load(body)
      if $('table.paging td').length > 0
        page_count = $('table.paging td').eq(4).find('a')[0].attribs.href.match(/'([^']+)'/g)[1]
        page_count = _.range(parseInt(page_count.replace(/\'/g,'')))
        f = []
        _.each page_count, (e)->
          f.push (cb)->
            request
              method: "POST"
              uri: base_url
              form: {
              "__EVENTARGUMENT": e+1
              }
            , (err, resp, body) ->
              console.log('there')
              throw err if err
              $ = cheerio.load(body)
              $('.tableZoekRes tbody tr').each ()->
                first = detail_url + $(this).find("td")[0].attribs.onclick.match(/'([^']+)'/g)[0].replace(/\'/g,'')
                second = detail_url + $(this).find("td")[2].attribs.onclick.match(/'([^']+)'/g)[0].replace(/\'/g,'')
                urls.push(first)
                urls.push(second)
              cb()

        async.parallel f, ()->
          ff = []
          _.each urls, (url)->
            ff.push (cb)->
              request url, (err, resp, body) ->
                throw err if err
                $ = cheerio.load(body)
                trs = $('.zoekDetailData tbody tr')
                model = if $('.zoekDetail thead td').eq(0).text().toLowerCase().indexOf('alfa romeo')>-1 then 'Alfa Romeo' else $('.zoekDetail thead td').eq(0).text().trim()
                make = $('.zoekDetail thead td').eq(0).replace(model, '').trim()
                obj =
                  image   : main_url + 'web/' + $('.zoekFotos').find('#mainPicture')[0].attribs.src.replace(/\.\.\//,'')
                  model   : model
                  make    : make
                  price   : if trs.eq(1).find('td')[1] then parseFloat(trs.eq(1).find('td').eq(1).text().trim().replace(/,/g,'.').replace('€',''))
                  mileage : if trs.eq(2).find('td')[1] then parseFloat(trs.eq(2).find('td').eq(1).text().trim().replace(/,/g,'.').replace('km',''))
                  year    : if trs.eq(4).find('td')[1] then trs.eq(4).find('td').eq(1).text().split('-')[2].trim()
                  fuel    : if trs.eq(5).find('td')[1] then trs.eq(5).find('td').eq(1).text().trim()
                  source  : "We have found this car on www.alphabetoccasions.nl"
                  url     : url
                if global.socket
                  global.socket.emit 'new-car', car: obj
                cars.push obj
                cb()
          async.series ff, ()->
            callback cars

module.exports = alphabetoccasion