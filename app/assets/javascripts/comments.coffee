# Setup collapse/expand functionality
jQuery.fn.collapsable = ->
    this
        .find('>blockquote >.meta')
        .prepend('<a class="collapse" title="Hide comments">←</a><a class="expand" title="Show comments">↪</a> ')
        .find('.collapse')
        .bind 'click', ->
            $(@).closest('li').addClass 'collapsed'
        .siblings('.expand')
        .bind 'click', ->
            $(@).closest('li').removeClass 'collapsed'

jQuery(document).ready ($) ->
    $comments = $('.comments')
    
    # Keeps the comment box open if it has data
    $comments
        .on 'keypress change blur', 'textarea', (e) ->
            if $.trim($(@).val()) is ''
                $(@).removeClass 'open'
            else
                $(@).addClass 'open'
        .on 'focus', 'textarea', (e) ->
            $li = $(@).closest 'li'
            $lis = $(@).closest('.comments').find('ol >li').not $li
            $lis.each ->
                $bq = $(@).find '>blockquote'
                if $.trim(bq.find('>form textarea').val()) is ''
                    $(@).removeClass 'editing replying'
                    $bq.find('>form').remove()
    
    # Inserts a new comment form beneath the comment being replied to 
    $comments
        .on 'ajax:error', '.reply[data-remote]', (xhr, status, error) ->
            $.alert 'Unable to make comment.'
        .on 'ajax:success', '.reply[data-remote]', (event, data, status, xhr) ->
            $li = $(@).closest 'li'
            $bq = $li.find '>blockquote'
            $bq.find('>form').remove()
            $li.addClass('replying')
            $li.removeClass('editing')
            $li.collapsable
            $bq.find('p').after(xhr.responseText)
            $bq.find('>form textarea').focus()
    
    # Inserts the a form into the DOM to edit the current comment
    $comments
        .on 'ajax:error', '.edit[data-remote]', (xhr, status, error) ->
            $.alert 'Unable to edit comment.'
        .on 'ajax:success', '.edit[data-remote]', (event, data, status, xhr) ->
            $li = $(@).closest 'li'
            $bq = $li.find '>blockquote'
            $p = $bq.find '>p'
            $li.addClass 'editing'
            $bq.find('>form').remove()
            $p.after xhr.responseText
            $bq.find('>form').trigger 'init'
    
    # Deletes a comment and updates the DOM
    $comments
        .on 'ajax:error', '.delete[data-remote]', (event, data, status, xhr) ->
            $.alert 'Unable to delete comment.'
        .on 'ajax:success', '.delete[data-remote]', (xhr, status, error) ->
            $li = $(@).closest 'li'
            $bq = $li.find '>blockquote'
            $li.addClass 'removed'
            $bq.find('.reply[data-remote]').after('<em>Comment was removed</em>').remove()
            $bq.find('.avatar img').animate { opacity: 0 }, 2000, -> $(@).remove()
            $bq.find('.body, .actions').remove()
            $bq.find('.meta').html('<time>Removed less than a minute ago</time>')
            $li.collapsable()
    
    # Locks a comment and updates the DOM
    $comments
        .on 'ajax:error', '.lock[data-remote]', (xhr, status, error) ->
            $.alert 'Unable to lock comment.'
        .on 'ajax:success', '.lock[data-remote]', (event, data, status, xhr) ->
            $li = $(@).closest 'li'
            $li.addClass('locked')
            $li.find('.reply[data-remote]').after('<em>Comment is locked</em>')
            $li.find('>ol >li').addClass 'collapsed'
    
    # Unlocks a comment and updates the DOM
    $comments
        .on 'ajax:error', '.unlock[data-remote]', (xhr, status, error) ->
            $.alert 'Unable to unlock comment.'
        .on 'ajax:success', '.unlock[data-remote]', (event, data, status, xhr) ->
            $li = $(@).closest 'li'
            $li.before xhr.responseText
            $liPrev = $li.prev()
            $liPrev.collapsable()
            $liPrev.find('li').collapsable()
            $liPrev.find('form').trigger 'init'
            $li.remove()
    
    # Checks the length of the comment before allowing user to submit
    $comments.on 'submit', 'form[data-remote]', ->
        comment = $(@).find('textarea').val()
        crCount = comment.length - comment.replace(/[\r\n]/g, '').length
        overrage = comment.length + crCount - 10000
        if overrage > 0
            $.alert
                title: 'Woops!'
                body: "Your comment is #{overrage} character#{if overrage > 1 then 's' else ''} too long."
            return false
    
    # Submits the comment and udpates the DOM
    $comments
        .on 'ajax:before', 'form[data-remote]', ->
            $(@).addClass 'busy'
        .on 'ajax:error', 'form[data-remote]', (xhr, status, error) ->
            $(@).removeClass 'busy'
            $.alert 'Error: unable to post comment.'
            $(@).find('textarea').focus()
        .on 'ajax:success', 'form[data-remote]', (event, data, status, xhr) ->
            if $(@).parents('li').length
                is_inline = true
                $container = $(@).closest 'li'
            else
                is_inline = false
                $container = $(@).closest '.comments'
            if !$container.find('>ol').length
                if is_inline
                    $container.append '<ol></ol>'
                else
                    $container.prepend '<ol></ol>'
            $(@)
                .removeClass('busy')
                .find('textarea')
                .removeClass('open')
                .val('')
                .blur()
            if $container.hasClass 'replying'
                $container.removeClass 'replying'
            if $container.hasClass 'editing'
                $container.before xhr.responseText
                $container = container.prev()
                $container.next().remove()
            else
                $container
                    .find('>ol')
                    .append(xhr.responseText)
                    .find('>li:last')
                    .css({ opacity: 0, marginLeft: -20 })
                    .animate({ opacity: 1, marginLeft: 0 }, 1000)
                if is_inline
                    offsetY = container.find('>ol li:last').offset().top
                    $(document).scrollTop(offsetY - 150)
                    $(@).remove()
            $container.find('>ol >li:last').collapsable()
        .on 'click', 'form[data-remote] .profile label', ->
            $(@).closest('form').find('textarea').focus()
    
    # Collapses children of locked comments
    $comments.find('li.locked >ol >li').addClass 'collapsed'
    
    # Collapses every 5th tier of comments
    $comments.find('li').collapsable()
    $comments.find('li').each ->
        unless ($(@).parents('li').length + 6) % 5
            $(@).find('>blockquote >.meta .collapse').trigger 'click'