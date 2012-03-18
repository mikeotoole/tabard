//= require jquery.ui.datepicker

$(document).ready ->

  $('#event_start_time_date, #event_end_time_date').each ->
    datef = $(this)
    nicef = datef.closest('li').find('input.nicedate')
    datef.datepicker({
      minDate: 0
      dateFormat: 'yy-mm-dd'
      altField: nicef
      altFormat: 'DD, MM d, yy'
      showOn: "button"
    })
    nicef.bind 'click focus', ->
      nicef.blur()
      datef.datepicker 'show'

  initSelects()