$(document).ready ->

  $('#tabs')
    .delegate 'dt a', 'click', ->
      return false unless !$.trim($(this).closest('dt').find('+ dd').html())
      $(this).closest('dt').find('+ dd').html 'Loading...'
  
  $('#bar')
    .delegate '.avatar .activities a', 'click', ->
      href = $(this).attr 'href'
      if $.trim(href) == $.trim(window.location)
        $('#tabs dt.activity a').trigger 'click'
        return false
    .delegate '.logo, .avatar > a, .avatar .characters a', 'click', ->
      href = $(this).attr 'href'
      if $.trim(href) == $.trim(window.location)
        $('#tabs dt.characters a').trigger 'click'
        return false

  hash = window.location.hash
  switch hash
    when '#characters'
      $('#tabs dt.characters a').trigger 'click'
      break
    else
      $('#tabs dt.activity a').trigger 'click'
      break