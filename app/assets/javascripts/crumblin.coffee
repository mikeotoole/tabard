$(document).ready ->

  # Home page community name field
  $('#homebox .url ins').data 'default', $('#homebox .url ins').html()
  $('#homebox input')
    .bind 'keyup change', ->
      text = $(this).val().toLowerCase().replace /[^a-z0-9]/g, ''
      $('#homebox .url ins').html text or= $('#homebox .url ins').data 'default'