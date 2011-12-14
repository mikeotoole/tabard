$(document).ready ->

  $('.more_activites')
    .bind 'ajax:beforeSend', ->
      $(this).closest('.submit').addClass('busy')
    .bind 'ajax:error', (xhr, status, error) ->
      $(this).closest('.submit').removeClass('busy')
      $.alert { body: 'Error: unable to load recent activity.' }
    .bind 'ajax:success', (event, data, status, xhr) ->
      alert 'herp a derp'