$(document).ready ->

  $('#tabs')
    .delegate 'dt a', 'click', ->
      #return false unless !$.trim($(this).closest('dt').find('+ dd').html())
      $(this).closest('dt').find('+ dd').html 'Loading...'

    .delegate 'dt.announcements + dd form', 'ajax:loading', ->
      $('#tabs dt.announcements + dd').html 'Loading...'
      
    .delegate 'dt.announcements + dd form', 'ajax:error', (xhr, status, error) ->
      $.alert { body: 'Unable to mark announcements as read.' }
      
    .delegate 'dt.announcements + dd form', 'ajax:complete', (event, data, status, xhr) ->
      $('#tabs dt.announcements a').trigger 'click'
  
  if $('#body.myprofile').length
    $('#bar')
      .delegate '.avatar .activities a', 'click', ->
        $('#tabs dt.activities a').trigger 'click'
        false
      .delegate '.dashboard .notice a', 'click', ->
        $('#tabs dt.announcements a').trigger 'click'
        false
      .delegate '.logo, .avatar > a, .avatar .characters a', 'click', ->
        $('#tabs dt.characters a').trigger 'click'
        false

  hash = window.location.hash
  switch hash
    when '#characters'
      $('#tabs dt.characters a').trigger 'click'
      break
    when '#announcements'
      $('#tabs dt.announcements a').trigger 'click'
      break
    else
      $('#tabs dt.activities a').trigger 'click'
      break