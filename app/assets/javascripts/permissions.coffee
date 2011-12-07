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
      $('#roles').addClass('busy')
    .bind 'ajax:error', (xhr, status, error) ->
      $(this).removeClass('busy')
      $.alert { body: 'Error: unable to load role.' }
    .bind 'ajax:success', (event, data, status, xhr) ->
      $('#role').html xhr.responseText
  
  $('#role .slider > input').bind 'click', ->
    $(this).prop 'checked', true
    $(this).parent().find('ul input').prop 'checked', false
    
  $('#role .slider ul input').bind 'click', ->
    $(this).closest('.slider').find('> input').prop 'checked', false