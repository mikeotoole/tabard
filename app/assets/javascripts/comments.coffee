# Setup collapse/expand functionality
jQuery.fn.collapsable = ->
  this
    .find('.meta')
    .prepend('<a class="collapse" title="Hide comments">←</a><a class="expand" title="Show comments">↪</a> ')
    .find('.collapse')
    .bind 'click', ->
      $(this).closest('li').addClass('collapsed')
    .siblings('.expand')
    .bind 'click', ->
      $(this).closest('li').removeClass('collapsed')

$(document).ready ->
  
  # Keeps the comment box open if it has data
  $('.comments textarea')
    .live 'keypress change blur', (e) ->
      if $.trim($(this).val()) == ''
        $(this).removeClass 'open'
      else
        $(this).addClass 'open'
    .live 'focus', (e) ->
      li = $(this).closest('li')
      lis = $(this).closest('.comments').find('ol >li').not(li)
      lis.each ->
        bq = $(this).find('>blockquote')
        if $.trim(bq.find('>form textarea').val()) == ''
          $(this).removeClass('editing replying')
          bq.find('>form').remove()
  
  # Inserts a new comment form beneath the comment being replied to 
  $('.comments .reply[data-remote]')
    .live 'ajax:error', (xhr, status, error) ->
      alert 'Unable to make comment.'
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(this).closest('li')
      bq = li.find('>blockquote')
      bq.find('>form').remove()
      li
        .addClass('replying')
        .removeClass('editing')
        .collapsable
      bq.find('p').after(xhr.responseText)
      bq
        .find('>form')
        .trigger('load')
        .find('textarea')
        .focus()
  
  # Inserts the a form into the DOM to edit the current comment
  $('.comments .edit[data-remote]')
    .live 'ajax:error', (xhr, status, error) ->
      alert 'Unable to edit comment.'
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(this).closest('li')
      bq = li.find('>blockquote')
      p = bq.find('>p')
      li.addClass('editing')
      bq.find('>form').remove()
      p.after(xhr.responseText)
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
        .animate { opacity: 0 }, 2000, ->
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
      $(this).closest('li')
        .addClass('locked')
        .find('>blockquote >p .reply[data-remote]')
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
  
  # Submits the comment and udpates the DOM
  $('.comments form[data-remote]')
    .live 'load', ->
      $(this)
        .bind 'ajax:beforeSend', ->
          $(this).addClass('busy')
        .bind 'ajax:error', (xhr, status, error) ->
          $(this).removeClass('busy')
          alert 'Error: unable to post comment.'
          $(this)
            .find('textarea')
            .focus()
        .bind 'ajax:success', (event, data, status, xhr) ->
          if $(this).parents('li').length
            is_inline = true
            container = $(this).closest('li')
          else
            is_inline = false
            container = $(this).closest('.comments')
          if !container.find('>ol').length
            container.append('<ol></ol>')
          $(this)
            .removeClass('busy')
            .find('textarea')
            .val('')
            .removeClass('open')
            .blur()
          if container.hasClass('replying')
            container.removeClass('replying')
          if container.hasClass('editing')
            container.before(xhr.responseText)
            container = container.prev()
            container.next().remove()
          else
            container
              .find('>ol')
              .append(xhr.responseText)
              .find('>li:last')
              .css({ opacity: 0, marginLeft: -20 })
              .animate({ opacity: 1, marginLeft: 0 }, 1000)
            if is_inline
              offsetY = container.find('>ol li:last').offset().top
              $(document).scrollTop(offsetY - 150)
              $(this).remove()
          container
            .find('>ol >li:last')
            .collapsable()
    .trigger 'load'
  
  $('.comments li').collapsable()
  $('.comments li').each ->
    unless ($(this).parents('li').length + 6) % 5
      $(this).find('>blockquote >.meta .collapse').trigger('click')