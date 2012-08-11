jQuery(document).ready ($) ->

  $('#roles')
    .on 'click', 'a', ->
      if $('#role').data 'changed'
        link = $(@)
        $.confirm
          title: 'Discard Changes?'
          body: 'Your changes will be lost if you switch roles without saving first. Are you sure you want to discard your changes to this role?'
          affirm: 'Discard'
          cancel: 'Go back'
          action: ->
            $('#role').data 'changed', false
            $(link).trigger 'click'
        return false
      return true
    .on 'ajax:before', 'a', ->
      $('#roles, #role').addClass 'busy'
      $('#permissions > dd').slideUp 200
    .on 'ajax:error', 'a', (xhr, status, error) ->
      $('#roles, #role').removeClass 'busy'
      $.alert body: 'Error: unable to load role.'
    .on 'ajax:success', 'a', (event, data, status, xhr) ->
      $('#roles a').removeClass 'active'
      $(@).addClass 'active'
      $('#roles, #role').removeClass 'busy'
      $('#role')
        .data('changed', false)
        .html(xhr.responseText)
        .find('.slider')
        .trigger 'init'
      $('#role_name').focus()
  
  $('#role')
    .on 'change', 'input, textarea', ->
      $('#role').data 'changed', true
    .on 'click', '#permissions > dt h2', ->
      dd = $(@).closest('dt').find '+ dd'
      dd.find('input').hide()
      dd.slideToggle 200, ->
        dd.find('input').show()
    .on 'ajax:before', 'form', ->
      $('#roles, #role').addClass 'busy'
    .on 'ajax:error', 'form', (xhr, status, error) ->
      $('#roles, #role').removeClass 'busy'
      $.alert body: 'Error: unable to save role.'
    .on 'ajax:success', 'form', (event, data, status, xhr) ->
      $('#roles, #role').removeClass 'busy'
      response = $.parseJSON xhr.responseText
      if response.success
        role = response.role
        $('#role').removeData 'changed'
        $.flash 'success', "The \"#{role.name}\" role has been saved." unless $('#flash .success').length
        unless $("#roles a[data-id=#{role.id}]").length
          $('#roles a').removeClass 'active'
          $('<li>').appendTo('#roles ul').append("<a href='/roles/#{role.id}/edit'>#{role.name}</a>").find('a').attr
            class: 'active'
            'data-id': role.id
            'data-type': 'text'
            'data-remote': 'true'
        $('#role').html(response.form).find('.slider').trigger('init') if response.form?
      else if response.error?
        $.alert body: response.error
      else
        $(@).trigger 'ajax:error'