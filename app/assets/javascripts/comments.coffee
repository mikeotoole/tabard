# Setup collapse/expand functionality
jQuery.fn.collapsable = ->
  this
    .find('>blockquote >.meta')
    .prepend('<a class="collapse" title="Hide comments">←</a><a class="expand" title="Show comments">↪</a> ')
    .find('.collapse')
    .bind 'click', ->
      $(@).closest('li').addClass('collapsed')
    .siblings('.expand')
    .bind 'click', ->
      $(@).closest('li').removeClass('collapsed')

jQuery(document).ready ($) ->
  
  # Keeps the comment box open if it has data
  $('.comments textarea')
    .live 'keypress change blur', (e) ->
      if $.trim($(@).val()) == ''
        $(@).removeClass('open')
      else
        $(@).addClass('open')
    .live 'focus', (e) ->
      li = $(@).closest('li')
      lis = $(@).closest('.comments').find('ol >li').not(li)
      lis.each ->
        bq = $(@).find('>blockquote')
        if $.trim(bq.find('>form textarea').val()) == ''
          $(@).removeClass('editing replying')
          bq.find('>form').remove()
  
  # Inserts a new comment form beneath the comment being replied to 
  $('.comments .reply[data-remote]')
    .live 'ajax:error', (xhr, status, error) ->
      $.alert { body: 'Unable to make comment.' }
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(@).closest('li')
      bq = li.find('>blockquote')
      bq.find('>form').remove()
      li
        .addClass('replying')
        .removeClass('editing')
        .collapsable
      bq.find('p').after(xhr.responseText)
      bq
        .find('>form')
        .trigger('init')
        .find('textarea')
        .focus()
  
  # Inserts the a form into the DOM to edit the current comment
  $('.comments .edit[data-remote]')
    .live 'ajax:error', (xhr, status, error) ->
      $.alert { body: 'Unable to edit comment.' }
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(@).closest('li')
      bq = li.find('>blockquote')
      p = bq.find('>p')
      li.addClass('editing')
      bq.find('>form').remove()
      p.after(xhr.responseText)
      bq.find('>form').trigger('init')
  
  # Deletes a comment and updates the DOM
  $('.comments .delete[data-remote]')
    .live 'ajax:error', (event, data, status, xhr) ->
      $.alert { body: 'Unable to delete comment.' }
    .live 'ajax:success', (xhr, status, error) ->
      li = $(@).closest('li')
      bq = li.find('>blockquote')
      li.addClass('removed')
      bq
        .find('.reply[data-remote]')
        .after('<em>Comment was removed</em>')
        .remove()
      bq
        .find('.avatar img')
        .animate { opacity: 0 }, 2000, ->
          $(@).remove()
      bq
        .find('.body, .actions')
        .remove()
      bq
        .find('.meta')
        .html('<time>Removed less than a minute ago</time>')
      li.collapsable()
  
  # Locks a comment and updates the DOM
  $('.comments .lock[data-remote]')
    .live 'ajax:error', (xhr, status, error) ->
      $.alert { body: 'Unable to lock comment.' }
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(@).closest('li')
      li
        .addClass('locked')
        .find('.reply[data-remote]')
        .after('<em>Comment is locked</em>')
      li.find('>ol >li').addClass('collapsed')
  
  # Unlocks a comment and updates the DOM
  $('.comments .unlock[data-remote]')
    .live 'ajax:error', (xhr, status, error) ->
      $.alert { body: 'Unable to unlock comment.' }
    .live 'ajax:success', (event, data, status, xhr) ->
      li = $(@).closest('li')
      li.before(xhr.responseText)
      li2 = li.prev()
      li2.collapsable()
      li2.find('li').collapsable()
      li2.find('form').trigger 'init'
      li.remove()
  
  # Submits the comment and udpates the DOM
  $('.comments form[data-remote]')
    .live 'init', ->
      $(@)
        .bind 'ajax:beforeSend', ->
          $(@).addClass('busy')
        .bind 'ajax:error', (xhr, status, error) ->
          $(@).removeClass('busy')
          $.alert { body: 'Error: unable to post comment.' }
          $(@).find('textarea').focus()
        .bind 'ajax:success', (event, data, status, xhr) ->
          if $(@).parents('li').length
            is_inline = true
            container = $(@).closest('li')
          else
            is_inline = false
            container = $(@).closest('.comments')
          if !container.find('>ol').length
            if is_inline
              container.append('<ol></ol>')
            else
              container.prepend('<ol></ol>')
          $(@)
            .removeClass('busy')
            .find('textarea')
            .removeClass('open')
            .val('')
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
              $(@).remove()
          container
            .find('>ol >li:last')
            .collapsable
      $(@)
        .find('.profile label')
        .bind 'click', ->
          $(@).closest('form').find('textarea').focus()
    .trigger 'init'
  
  # Collapses children of locked comments
  $('.comments li.locked >ol >li').addClass 'collapsed'
  
  # Collapses every 5th tier of comments
  $('.comments li').collapsable()
  $('.comments li').each ->
    unless ($(@).parents('li').length + 6) % 5
      $(@).find('>blockquote >.meta .collapse').trigger('click')