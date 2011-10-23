$(document).ready ->
  
  # mailbox checkbox select (for visual enhancement)
  $('#mailbox .meta input[type="checkbox"]')
    .bind 'click change', ->
      if $(this).filter(':checked').length
        $(this).closest('dd').addClass 'selected'
      else
        $(this).closest('dd').removeClass 'selected'
  
  # user profile suggestion and selection for the "to" field
  $('#message.compose').each ->
    
    $('#message_to')
      .bind 'focus blur keyup change', (e)->
        text = $.trim $(this).val().toLowerCase()
        if text.length < 1
          $('aside label').hide()
        else
          $('aside label').each ->
            id = $(this).attr 'for'
            display = if !$('#'+id+':checked').length && $(this).html().toLowerCase().match(text) then 'block' else 'none'
            $(this).css('display', display)
            $('aside li').removeClass 'first last'
            visible = $('aside li:has(label:visible)')
            visible.filter(':first').addClass 'first'
            visible.filter(':last').addClass 'last'
    
    $('aside label')
      .click ->
        $('#message_to').val('').focus()
        $('aside label').hide()
  
    $('header li input[type="checkbox"]')
      .change ->
        updateMessageHeaderHeight()
    
    $('#message_body')
      .bind 'focus keypress', ->
        updateMessageHeaderHeight()
    
    updateMessageHeaderHeight()
    
  # auto-focus the correct field
  if !$('#message_subject').val()
    $('#message_subject').focus()
  else if !$('#message_to').val()
    $('#message_to').focus()
  else
    $('#message_body').focus()
    
updateMessageHeaderHeight = ->
  $('#message.compose article').css({ top: $('header').height() + 35 })