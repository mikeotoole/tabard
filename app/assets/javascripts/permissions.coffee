$(document).ready ->

  $('#roles')
    .delegate 'a', 'click', ->
      if $('#role').data 'changed'
        link = $(@)
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
    .delegate 'a', 'ajax:beforeSend', ->
      $('#roles, #role').addClass('busy')
      $('#permissions > dd').slideUp 200
    .delegate 'a', 'ajax:error', (xhr, status, error) ->
      $('#roles, #role').removeClass('busy')
      $.alert { body: 'Error: unable to load role.' }
    .delegate 'a', 'ajax:success', (event, data, status, xhr) ->
      $('#roles a').removeClass('active')
      $(@).addClass('active')
      $('#roles, #role').removeClass('busy')
      $('#role')
        .data('changed', false)
        .html(xhr.responseText)
        .find('.slider')
        .trigger 'init'
  
  $('#role')
    .delegate 'input, textarea', 'change', ->
      $('#role').data 'changed', true
    .delegate '#permissions > dt h2', 'click', ->
      dd = $(@).closest('dt').find('+ dd')
      dd.find('input').hide()
      dd.slideToggle 200, ->
        dd.find('input').show()