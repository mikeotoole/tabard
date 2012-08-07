jQuery(document).ready ($) ->

  $('#tabs')
    .on 'ajax:before', 'dt > a', ->
      $(@).closest('dt').find('+ dd').html ''
    .on 'ajax:error', 'dt.announcements + dd form', (xhr, status, error) ->
      $.alert body: 'Unable to mark announcements as read.'
    .on 'ajax:complete', 'dt.announcements + dd form', (event, data, status, xhr) ->
      $('#tabs dt.announcements a').trigger 'click'
  
  if $('#body.myprofile').length
    $('#bar')
      .on 'click', '.avatar .activities a', ->
        $('#tabs dt.activities a').trigger 'click'
        false
      .on 'click','.dashboard .calendar a',  ->
        $('#tabs dt.invites a').trigger 'click'
        false
      .on 'click','.dashboard .notice a', ->
        $('#tabs dt.announcements a').trigger 'click'
        false
      .on 'click','.logo, .avatar > a, .avatar .characters a', ->
        $('#tabs dt.characters a').trigger 'click'
        false

  hash = window.location.hash
  switch hash
    when '#invites'
      $('#tabs dt.invites a').trigger 'click'
    when '#characters'
      $('#tabs dt.characters a').trigger 'click'
    when '#announcements'
      $('#tabs dt.announcements a').trigger 'click'
    when '#roles'
      $('#tabs dt.roles a').trigger 'click'
    else
      $('#tabs dt.activities a').trigger 'click'

  # Batch invites action
  $('#body')
    .on 'ajax:error', '#invites_batch', (xhr, status, error) ->
      $.alert body: error
    .on 'ajax:success', '#invites_batch', (event, data, status, xhr) ->
      response = $.parseJSON xhr.responseText
      if response.success
        $("#invites_batch tr[invite='#{invite.id}'] td.status strong").text invite.status for invite in response.invites
        $("#invites_batch td.check input").removeAttr 'checked'
      else
        $.alert body: response.message

  # Role assignment toggling
  $('#body')
    .on 'ajax:before', '#tabs dd .checkboxes a', ->
      $(@).closest('li').addClass 'busy'
    .on 'ajax:success', '#tabs dd .checkboxes a', (event, data, status, xhr) ->
      $(@).closest('li').removeClass 'busy'
      response = $.parseJSON xhr.responseText
      if response.success
        if response.assigned
          $(@).closest('li').addClass 'checked'
        else
          $(@).closest('li').removeClass 'checked'
      else
        $.alert body: 'Error. Unable to assign role.'