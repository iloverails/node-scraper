casper = require('casper').create
  clientScripts: ["./includes/jquery.min.js"]

casper.start 'http://www.leaseplan.nl/occasions/'

casper.thenEvaluate ()->
  document.querySelector('select#nrOfItems').value='1000'
, 'CasperJS'

casper.then ()->
  @evaluate ->
    console.log document

casper.run ->
