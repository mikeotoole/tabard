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
      .bind 'focus blur keyup change', ->
        text = $.trim $(this).val().toLowerCase()
        $('aside ul, aside label').hide()
        if text.length
          showcount = 0
          $('aside label').each ->
            id = $(this).attr 'for'
            display = 'none'
            if showcount < 5 && !$('#'+id+':checked').length && $(this).html().toLowerCase().match(text)
              showcount++
              display = 'block'
              $(this).css('display', display)
          if showcount > 0
            $('aside ul').show()
            updateMessageListClasses()
    
    $('aside label')
      .click ->
        $('#message_to').val('').focus()
        updateMessageListClasses()
        $('aside ul, aside label').hide()
  
    $('header li input[type="checkbox"]')
      .change ->
        updateMessageHeaderHeight()
    
    $('#message_subject, #message_body')
      .bind 'focus keypress', ->
        updateMessageListClasses()
        $('aside ul, aside label').hide()
    
    $('mark')
      .click ->
        $(this).animate({ opacity: 0}, 200, 'linear')
    
    updateMessageHeaderHeight()
    
  # auto-focus the correct field
  if !$('#message_subject').val()
    $('#message_subject').focus()
  else if $('aside li:has(label:visible)').length > 0
    $('#message_to').focus()
  else
    $('#message_body').focus()
  
  # Toggle check/uncheck box for messages
  $('#mailbox-menu .actions')
    .after('<dd class="toggle"><button type="button" meta="Check/uncheck all messages">Check/uncheck all messages</button></dd>')
    .closest('dl')
    .find('.toggle button')
    .data('checked',false)
    .click ->
      $(this).data('checked',!$(this).data('checked'))
      $('#mailbox dd .meta input').attr('checked',$(this).data('checked'))
    
updateMessageHeaderHeight = ->
  $('#message.compose article').css({ top: $('header').height() + 35 })

updateMessageListClasses = ->
  $('aside li').removeClass 'first last'
  visible = $('aside li:has(label:visible)')
  visible.filter(':first').addClass 'first'
  visible.filter(':last').addClass 'last'