jQuery(document).ready ($) ->

  # Date Picker
  $('#event_start_time_date, #event_end_time_date').each ->
    datef = $(@)
    nicef = datef.closest('li').find('input.nicedate')
    datef.datepicker
      minDate: 0
      dateFormat: 'yy-mm-dd'
      altField: nicef
      altFormat: 'DD, MM d, yy'
      showOn: "button"
    nicef.bind 'click focus', ->
      nicef.blur()
      datef.datepicker 'show'

  # Hour/min field
  $('#event').on 'change blur', '.time input', ->
    val = $(@).val()
    val += 'pm' unless val.match /a|p\.*m/i
    $(@).val moment(val,'h:mm a').format 'h:mm a'

  # Game dropdown character filtering
  $('label[for="event_supported_game_id"] + ul input[type="radio"]').change ->
    sgId = $(@).closest('ul').find('input[type="radio"]:checked').val()
    chars = $('table.invites tbody td.characters ul li')
    if sgId
      chars.hide()
      chars.find('img.sg_'+sgId).closest('li').show()
    else
      chars.show()
    false
  
  # Toggle action for rows
  $('table.invites td.actions a.toggle').click ->
    row = $(@).closest('tr')
    if $(@).hasClass('approve')
      $(@).removeClass('approve').addClass('reject')
      row.addClass 'dim'
      row.find('input[name*="_destroy"]').val(true)
    else
      $(@).removeClass('reject').addClass('approve')
      row.removeClass 'dim'
      row.find('input[name*="_destroy"]').val(false)
    return false
  
  # Global checkbox for rows
  $('table.invites thead th:last').each ->
    invitedRows = $(@).closest('table').find('tbody tr')
    if invitedRows.length > 0
      checka = $('<a>').appendTo @
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