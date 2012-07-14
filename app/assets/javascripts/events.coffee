$(document).ready ->

  # Date Picker
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
  
  # Game dropdown character filtering
  $('label[for="event_supported_game_id"] + ul input[type="radio"]').change ->
    sgId = $(this).closest('ul').find('input[type="radio"]:checked').val()
    chars = $('table.invites tbody td.characters ul li')
    if sgId
      chars.hide()
      chars.find('img.sg_'+sgId).closest('li').show()
    else
      chars.show()
    false
  
  # Toggle action for rows
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
  
  # Global checkbox for rows
  $('table.invites thead th:last').each ->
    invitedRows = $(this).closest('table').find('tbody tr')
    if invitedRows.length > 0
      $(this).html('<a>✔</a>')
      checka = $(this).find('a')
      checka.addClass('checked') if invitedRows.find('td.actions a.approve').length == invitedRows.length
      checka.click ->
        if invitedRows.find('td.actions a.approve').length == invitedRows.length
          invitedRows
            .find('td.actions a.toggle')
            .removeClass('reject')
            .addClass('approve')
            .trigger 'click'
        else
          invitedRows
            .find('td.actions a.toggle')
            .removeClass('approve')
            .addClass('reject')
            .trigger 'click'
        false
    false

  initSelects()