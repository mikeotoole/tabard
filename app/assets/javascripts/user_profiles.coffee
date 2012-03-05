$(document).ready ->

  $('#tabs')
    .delegate 'dt a', 'click', ->
      return false unless !$.trim($(this).closest('dt').find('+ dd').html())
  
  $('#bar .avatar').click ->
    $('#tabs dt.characters a').trigger 'click'

  hash = window.location.hash
  switch hash
    when '#characters'
      $('#tabs dt.characters a').trigger 'click'
      break
    else
      $('#tabs dt.activity a').trigger 'click'
      break