$(document).ready ->

  $('#mailbox .meta input[type="checkbox"]')
    .bind 'click change', ->
      if $(this).filter(':checked').length
        $(this).closest('dd').addClass 'selected'
      else
        $(this).closest('dd').removeClass 'selected'
  
  $('#message.compose #message_subject')
    .each ->
      if($(this).val())
        $('#message_body').focus()
      else
        $(this).focus()
    .focus ->
      false

  $('header li li input').prop('checked','checked')
  $('#message.compose article').css({ top: $('header').height() + 35 })