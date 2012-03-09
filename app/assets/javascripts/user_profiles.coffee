$(document).ready ->

  $('#tabs')
    .delegate 'dt a', 'click', ->
      return false unless !$.trim($(this).closest('dt').find('+ dd').html())
      $(this).closest('dt').find('+ dd').html 'Loading...'
  
  $('#bar')
    .delegate '.avatar .profile a', 'click', ->
      $('#tabs dt.activities a').trigger 'click'
      false
    .delegate '.logo, .avatar > a, .avatar .characters a', 'click', ->
      $('#tabs dt.characters a').trigger 'click'
      false

  hash = window.location.hash
  switch hash
    when '#characters'
      $('#tabs dt.characters a').trigger 'click'
      break
    else
      $('#tabs dt.activity a').trigger 'click'
      break