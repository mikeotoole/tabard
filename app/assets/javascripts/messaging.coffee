jQuery(document).ready ($) ->

  # mailbox checkbox select (for visual enhancement)
  $('#mailbox .meta input[type="checkbox"]')
    .bind 'click change', ->
      if $(@).filter(':checked').length
        $(@).closest('dd').addClass 'selected'
      else
        $(@).closest('dd').removeClass 'selected'
  
  # message AJAX load
  $('#mailbox')
    .on 'ajax:before', 'dd a[data-remote]', ->
      $('#message').addClass 'busy'
    .on 'ajax:complete', 'dd a[data-remote]', ->
      $('#message').removeClass 'busy'
    .on 'ajax:error', 'dd a[data-remote]', (xhr, status, error) ->
      $.alert body: 'Unable to load message.'
    .on 'ajax:success', 'dd a[data-remote]', (event, data, status, xhr) ->
      $('#mailbox dd').removeClass 'open'
      dd = $(@).closest('dd')
      if dd.hasClass 'read'
        dd.addClass 'open'
      else
        envelope = $('#bar .envelope a')
        num = envelope.attr('meta') - 1
        if num
          envelope.attr('meta', num)
        else
          envelope.removeAttr 'meta'
        dd.addClass 'read open'
      $('#message').html xhr.responseText
      if typeof(history.replaceState) is typeof(Function)
        history.replaceState {}, $('#message h1').text(), $('#message header').attr 'slug'
  
  # user profile suggestion and selection for the "to" field
  $('#message.compose').each ->
    
    $('#message_to')
      .bind 'focus blur keyup change', ->
        text = $.trim $(@).val().toLowerCase()
        $('aside ul, aside label').hide()
        if text.length
          showcount = 0
          $('aside label').each ->
            id = $(@).attr 'for'
            display = 'none'
            if showcount < 5 && !$('#'+id+':checked').length && $(@).html().toLowerCase().match(text)
              showcount++
              display = 'block'
              $(@).css('display', display)
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
        $(@).animate({ opacity: 0}, 200, 'linear')
    
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
      $(@).data('checked',!$(@).data('checked'))
      $('#mailbox dd .meta input').attr('checked',$(@).data('checked'))
    
updateMessageHeaderHeight = ->
  $('#message.compose article').css({ top: $('header').height() + 35 })

updateMessageListClasses = ->
  $('aside li').removeClass 'first last'
  visible = $('aside li:has(label:visible)')
  visible.filter(':first').addClass 'first'
  visible.filter(':last').addClass 'last'