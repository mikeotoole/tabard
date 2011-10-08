$(document).ready ->
  
  $('.comments textarea')
    .live 'keypress change blur', (e) ->
      if $.trim($(this).val()) == ''
        $(this).removeClass 'open'
      else
        $(this).addClass 'open'
        
  $('.comments .reply')
    .data('type', 'html')
    .live 'ajax:success', (event, data, status, xhr) ->
      alert(data)
      # $(this).after(data)
    .live 'ajax:error', (xhr, status, error) ->
      alert error
        
  $('.comments .delete')
    .live 'ajax:success', (event, data, status, xhr) ->
      alert 'Unable to delete comment.'
    .live 'ajax:error', (xhr, status, error) ->
      blockquote = $(this).closest('li').find('>blockquote')
      blockquote
        .addClass('deleted')
        .find('.reply')
        .after('<em>Comment was deleted</em>')
        .remove()
      blockquote
        .find('.avatar img')
        .animate { opacity: 0 }, 2000, () ->
          $(this).remove()
      blockquote
        .find('.body')
        .remove()
        
  $('.comments .lock')
    .live 'ajax:success', (event, data, status, xhr) ->
      alert 'Unable to lock comment.'
    .live 'ajax:error', (xhr, status, error) ->
      $(this)
        .closest('li')
        .addClass('locked')
        .find('>blockquote .reply')
        .after('<em>Comment is locked</em>')
        
  $('.comments .unlock')
    .live 'ajax:success', (event, data, status, xhr) ->
      alert 'Unable to unlock comment.'
    .live 'ajax:error', (xhr, status, error) ->
      $(this)
        .closest('li')
        .removeClass('locked')
        .find('em')
        .remove()
  
  $('.comments form[data-remote]')
    .data('type', 'html')
    .live 'load', () ->
      $(this)
        .bind 'ajax:beforeSend', () ->
          $(this)
            .addClass('busy')
            .prop('disabled', true)
        .bind 'ajax:error', (xhr, status, error) ->
          $(this)
            .removeClass('busy')
            .find('textarea')
            .removeProp('disabled')
          alert 'Error: unable to post comment.'
          $(this)
            .find('textarea')
            .focus()
        .bind 'ajax:success', (event, data, status, xhr) ->
          $(this)
            .removeClass('busy')
            .find('textarea')
            .val('')
            .removeClass('open')
            .removeProp('disabled')
          $(this)
            .closest('.comments')
            .find('ol:first')
            .append(data)
            .find('li:last')
            .css({ opacity: 0 })
            .animate({ opacity: 1 }, 500)
          $(this)
            .find('textarea')
            .blur()
    .trigger 'load'