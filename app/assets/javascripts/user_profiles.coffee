$(document).ready ->

  $('#tabs')
    .delegate 'dt a', 'click', ->
      return false unless !$.trim($(this).closest('dt').find('+ dd').html())
      
    .delegate 'dt.activity a', 'ajax:error', (xhr, status, error) ->
      $.alert { body: 'Error: unable to load recent activity.' }
    .delegate 'dt.activity a', 'ajax:success', (event, data, status, xhr) ->
      $('#tabs dt.activity + dd').html xhr.responseText
      
    .delegate 'dt.characters a', 'ajax:error', (xhr, status, error) ->
      $.alert { body: 'Error: unable to load characterss.' }
    .delegate 'dt.characters a', 'ajax:success', (event, data, status, xhr) ->
      $('#tabs dt.characters + dd').html xhr.responseText
  
  $('#bar .avatar').click ->
    $('#tabs dt.characters a').trigger 'click'

  hash = window.location.hash
  switch hash
    when '#characters'
      $('#tabs dt.characters a').trigger 'click'
      $('#tabs dt.characters + dd').html 'Loading...'
      break
    else
      $('#tabs dt.activity a').trigger 'click'
      $('#tabs dt.activity + dd').html 'Loading...'
      break