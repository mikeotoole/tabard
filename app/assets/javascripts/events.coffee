//= require jquery.ui.datepicker

$(document).ready ->

  $('#event_start_time, #event_end_time').each ->
    datef = $(this)
    nicef = datef.closest('li').find('input.nicedate')
    datef.datepicker({
      minDate: 0
      dateFormat: 'yy-mm-dd'
      altField: nicef
      altFormat: 'DD, d MM, yy'
      showOn: "button"
    })
    nicef.bind 'click focus', ->
      nicef.blur()
      datef.datepicker 'show'
  
  $('form.event').bind 'submit', ->
    $('#event_start_time, #event_end_time').each ->
      datef = $(this)
      datetime = datef.closest('.datetime')
      hour = datetime.find('.select.hour input:checked').val()
      minute = datetime.find('.select.minute input:checked').val()
      meridian = datetime.find('.select.meridian input:checked').val()
      if meridian == 'PM' then hour = hour * 1 + 12
      if hour < 10 then hour = '0' + hour
      timestamp = datef.val() + ' ' + hour + ':' + minute + ':00'
      datef.val timestamp

  initSelects()