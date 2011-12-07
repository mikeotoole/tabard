$(document).ready ->

  $('#roles a')
    .bind 'click', ->
      if $('#role').data 'changed'
        link = $(this)
        $.confirm {
          title: 'Discard Changes?'
          body: 'Your changes will be lost if you switch roles without saving first. Are you sure you want to discard your changes to this role?'
          affirm: 'Discard'
          cancel: 'Go back'
          action: ->
            $('#role').data 'changed', false
            $(link).trigger 'click'
        }
        return false
      return true
    .bind 'ajax:beforeSend', ->
      $('#roles, #role').addClass('busy')
      $('#permissions > dd').slideUp 200
    .bind 'ajax:error', (xhr, status, error) ->
      $('#roles, #role').removeClass('busy')
      $.alert { body: 'Error: unable to load role.' }
    .bind 'ajax:success', (event, data, status, xhr) ->
      $('#roles a').removeClass('active')
      $(this).addClass('active')
      $('#roles, #role').removeClass('busy')
      $('#role')
        .data('changed', false)
        .html(xhr.responseText)
        .find('.slider, .slider_with_none')
        .trigger 'init'
  
  $('#role input, textarea').live 'change', ->
    $('#role').data 'changed', true
  
  $('#permissions > dt h2').live 'click', ->
    $(this).closest('dt').find('+ dd input[type="checkbox"]').hide()
    $(this).closest('dt').find('+ dd').slideToggle 200, ->
      $(this).find('input[type="checkbox"]').show()