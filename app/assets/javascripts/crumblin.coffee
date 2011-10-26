$(document).ready ->

  # Home page community name field
  $('#homebox input')
    .bind 'keyup change', (e) ->
      code = if e.keyCode then e.keyCode else e.which
      alert code