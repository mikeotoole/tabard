$(document).ready ->

  # Cancel button for newly added permissions
  $('form.role .actions .cancel')
    .live 'click', ->
      $(this).closest('tr').remove()
  
  # Adds new permission form fields to the DOM
  $('form.role tfoot .new')
    .bind 'ajax:beforeSend', ->
      $(this).addClass('busy')
    .bind 'ajax:error', (xhr, status, error) ->
      $(this).removeClass('busy')
      $.alert { body: 'Error: unable to create new permission.' }
    .bind 'ajax:success', (event, data, status, xhr) ->
      $(this).removeClass('busy')
      tbody = $(this).closest('table').find('tbody')
      tbody.append xhr.responseText