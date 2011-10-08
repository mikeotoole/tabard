$(document).ready ->
  
  # Keeps the comment box open if it has data
  $('.comments textarea')
    .live 'keypress change blur', (e) ->
      if $.trim($(this).val()) == ''
        $(this).removeClass 'open'
      else
        $(this).addClass 'open'
    .live 'blur', (e) ->
      li = $(this).closest('li')
      if li.length and $.trim($(this).val()) == ''
        li
          .find('>blockquote >p').show()
          .find('.reply[data-remote]').show()
        $(this).closest('form').remove()
  
  # Inserts a new comment form beneath the comment being replied to 
  $('.comments .reply[data-remote]')
    .data('type', 'html')
    .live 'ajax:error', (xhr, status, error) ->
      alert 'Unable to make comment.'
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(this).closest('li')
      bq = li.find('>blockquote')
      $(this).hide()
      bq.find('>form').remove()
      li.removeClass('editing')
      bq.find('p').after(data)
      bq
        .find('form')
        .trigger('load')
        .find('textarea')
        .focus()
  
  # Inserts the a form into the DOM to edit the current comment
  $('.comments .edit[data-remote]')
    .data('type','html')
    .live 'click', () ->
      $(this).closest('li').find('>blockquote >form').remove()
    .live 'ajax:error', (xhr, status, error) ->
      alert 'Unable to edit comment.'
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(this).closest('li')
      bq = li.find('>blockquote')
      p = li.find('>p')
      li.addClass('editing')
      p.after(data)
      p.find('.body').hide()
      bq.find('>form').trigger('load')
  
  # Deletes a comment and updates the DOM
  $('.comments .delete[data-remote]')
    .live 'ajax:error', (event, data, status, xhr) ->
      alert 'Unable to delete comment.'
    .live 'ajax:success', (xhr, status, error) ->
      li = $(this).closest('li')
      bq = li.find('>blockquote')
      li.addClass('deleted')
      bq
        .find('.reply[data-remote]')
        .after('<em>Comment was deleted</em>')
        .remove()
      bq
        .find('.avatar img')
        .animate { opacity: 0 }, 2000, () ->
          $(this).remove()
      bq
        .find('.body, .actions')
        .remove()
      bq
        .find('.meta')
        .html('<time>Deleted less than a minute ago</time>')
  
  # Locks a comment and updates the DOM
  $('.comments .lock[data-remote]')
    .live 'ajax:error', (event, data, status, xhr) ->
      alert 'Unable to lock comment.'
    .live 'ajax:success', (xhr, status, error) ->
      $(this)
        .closest('li')
        .addClass('locked')
        .find('>blockquote >p .reply[data-remote]')
        .hide()
        .after('<em>Comment is locked</em>')
  
  # Unlocks a comment and updates the DOM   
  $('.comments .unlock[data-remote]')
    .live 'ajax:error', (event, data, status, xhr) ->
      alert 'Unable to unlock comment.'
    .live 'ajax:success', (xhr, status, error) ->
      li = $(this).closest('li')
      p = li.find('>blockquote >p')
      li.removeClass('locked')
      p.find('em').remove()
      p.find('.reply[data-remote]').show()
  
  # Submits the comment and udpates the DOM
  $('.comments form[data-remote]')
    .live 'load', () ->
      $(this)
        .data('type', 'html')
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
          if $(this).parents('li').length
            is_inline = true
            container = $(this).closest('li')
            if !container.find('>ol').length
              container.append('<ol></ol>')
          else
            is_inline = false
            container = $(this).closest('.comments')
          $(this)
            .removeClass('busy')
            .find('textarea')
            .val('')
            .removeClass('open')
            .removeProp('disabled')
            .find('textarea')
            .blur()
          if container.hasClass('editing')
            container
              .replaceWith(data)
              .find('a[data-remote]')
              .data('type', 'html')
          else
            container
              .find('>ol')
              .append(data)
              .find('>li:last')
              .css({ opacity: 0 })
              .animate({ opacity: 1 }, 500)
              .find('a[data-remote]')
              .data('type', 'html')
            if is_inline
              $(this)
                .closest('li')
                .find('.reply[data-remote]')
                .show()
              $(this).remove()
            else
              # $(this).trigger('load')
    .trigger 'load'