$(document).ready ->

  $('#roles').data 'changed', false
  $('#roles li')
    .bind 'click', ->
      if $('#roles').data 'changed'
        $.confirm {
          title: 'Wait'
          body: 'Your changes will be lost if you switch to editing a different role.'
          affirm: 'Discard Changes'
          action: ->
            $('#roles').data 'changed', false
            $(this).trigger 'click'
        }
        false
    .bind 'ajax:beforeSend', ->
      $('#roles, #role').addClass('busy')
    .bind 'ajax:error', (xhr, status, error) ->
      $('#roles, #role').removeClass('busy')
      $.alert { body: 'Error: unable to load role.' }
    .bind 'ajax:success', (event, data, status, xhr) ->
      $('#roles li').removeClass('active')
      $(this).addClass('active')
      $('#roles, #role').removeClass('busy')
      $('#role').html xhr.responseText
  
  $('#permissions > dt h2').click ->
    $(this).closest('dt').find('+ dd').slideToggle 200