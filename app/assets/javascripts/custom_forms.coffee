$(document).ready ->

  $('.add a')
    .bind 'ajax:beforeSend', ->
      $(this).closest('.add').addClass('busy')
    .bind 'ajax:error', (xhr, status, error) ->
      $(this).closest('.add').removeClass('busy')
      $.alert { body: 'Error: unable to add question.' }
    .bind 'ajax:success', (event, data, status, xhr) ->
      $.alert { body: data.responseText }