$(function() {
  var cars = []
  var socket = io.connect('http://'+location.host)
  $('#filter_search').click(function(){
    $.get('/search',{
      model:$('#filter_model').val(),
      make:$('#filter_make').val(),
      fuel:$('#filter_fuel').val(),
      year_from:$('#filter_year_from').val(),
      year_to: $('#filter_year_to').val(),
      mileage: $('#filter_mileage').val(),
      price_from: $('#filter_price_from').val(),
      price_to: $('#filter_price_to').val()},
      function(res){

    })
  })
  socket.on('new-car', function(data){
    cars.push(data)
    JST.fetch('car', function (res) {
      res(
        car = data.car
      )
      $('table#main-content-search tbody').append(res)
    })
  })
});
