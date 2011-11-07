$(document).ready ->

  # Home page community name field
  $('#homebox .url ins').data 'default', $('#homebox .url ins').html()
  $('#homebox input')
    .bind 'keyup change', ->
      text = $(this).val().toLowerCase().replace /[^a-z0-9]/g, ''
      $('#homebox .url ins').html text or= $('#homebox .url ins').data 'default'
  
  # Enforce document scrolling
  $('.document .scroll')
    .wrapInner('<div class="pane" />')
    .css('height', 190)
    .bind 'scroll', ->
      boxH = $(this).height()
      paneH = $(this).find('.pane').height()
      if paneH <= boxH || $(this).scrollTop() >= paneH - boxH
        $(this)
          .closest('.document')
          .find('.accept')
          .css({ opacity: 1 })
          .find('input')
          .removeAttr('disabled')
          .find('+ label')
          .unbind 'click'
  $('.document .scroll .accept input[type="checkbox"]:not(:checked)')
    .attr('disabled', true)
    .closest('.accept')
    .css({ opacity: .5 })
  $('.document .scroll .accept label')
    .bind 'click', ->
      if $(this).closest('.accept').find('input:disabled')
        $.alert { body: "Make sure that you read and <b>scroll to the end</b> of each document before accepting the terms." }
        false
      else
        true
  $('.document .scroll').trigger 'scroll'