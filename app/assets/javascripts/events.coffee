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
  
  $('table.invites td.actions a.toggle').click ->
    row = $(this).closest('tr')
    if $(this).hasClass('approve')
      $(this).removeClass('approve').addClass('reject')
      row.addClass 'dim'
      row.find('input[name*="_destroy"]').val(true)
    else
      $(this).removeClass('reject').addClass('approve')
      row.removeClass 'dim'
      row.find('input[name*="_destroy"]').val(false)
    return false

  initSelects()