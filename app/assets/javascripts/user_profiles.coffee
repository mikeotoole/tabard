jQuery(document).ready ($) ->

  $('#tabs')
    # Clear tab before before loading new stuff
    .on 'ajax:before', 'dt > a', ->
      $(@).closest('dt').find('+ dd').html ''
    # Announcements
    .on 'ajax:error', 'dt.announcements + dd form', (xhr, status, error) ->
      $.alert 'Unable to mark announcements as read.'
    .on 'ajax:complete', 'dt.announcements + dd form', (event, data, status, xhr) ->
      $('#tabs dt.announcements a').trigger 'click'
    # Update window history on tabl switching
    .on 'ajax:success', 'dt > a', ->
      if typeof(history.replaceState) is typeof(Function)
        hash = $(@).closest('dt').prop('class').split(' ').shift()
        history.replaceState {}, $(@).text(), "##{hash}"

  # Links rom user bar that activate tabs instead of full page reloads
  if $('#body:has(header.myprofile)').length
    $('#bar')
      .on 'click','.avatar > a', ->
        $('#tabs dt.games a').trigger 'click'
        false
      .on 'click','.dashboard .notice a', ->
        $('#tabs dt.announcements a').trigger 'click'
        false
      .on 'click','.dashboard .calendar a', ->
        $('#tabs dt.invites a').trigger 'click'
        false

  hash = window.location.hash
  switch hash
    when '#invites'
      $('#tabs dt.invites a').trigger 'click'
    when '#games'
      $('#tabs dt.games a').trigger 'click'
    when '#announcements'
      $('#tabs dt.announcements a').trigger 'click'
    when '#roles'
      $('#tabs dt.roles a').trigger 'click'
    else
      $('#tabs dt.activities a').trigger 'click'

  # Batch invites action
  $('#body')
    .on 'ajax:error', '#invites_batch', (xhr, status, error) ->
      $.alert error
    .on 'ajax:success', '#invites_batch', (event, data, status, xhr) ->
      response = $.parseJSON xhr.responseText
      if response.success
        $("#invites_batch tr[invite='#{invite.id}'] td.status strong").text invite.status for invite in response.invites
        $("#invites_batch td.check input").removeAttr 'checked'
        if response.fresh_invites_count > 0
          $('#bar .dashboard .calendar a').attr 'meta', response.fresh_invites_count
        else
          $('#bar .dashboard .calendar a').removeAttr 'meta'
      else
        $.alert response.message

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
        $.alert 'Error. Unable to assign role.'

  # Games/Charactesr
  $('#body')
    .on 'click', '#tabs dt.games + dd h2', (e) ->
      $(@).toggleClass 'closed' if @ is e.target