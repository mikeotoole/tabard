((jQuery) ->

  # Grabs the next page and dumps it into the DOM
  $.endlessPageNext = (node) ->
    return if node.hasClass 'busy'
    node.addClass 'busy'
    pagination = node.find('.pagination:last')
    current_page = node.attr('current_page') * 1
    next_page = current_page + 1
    if next_page <= node.attr 'last_page'
      $.ajax
        url: node.attr('action') + '?page=' + next_page
        dataType: 'text'
        complete: ->
          setTimeout (-> node.removeClass 'busy'), 100
        success: (data, status, xhr) ->
          response = $.parseJSON xhr.responseText
          return unless response.success and response.items?
          node
            .attr('current_page', next_page)
            .find(node.attr('target'))
            .append response.items

  # Finds elements that need endless scrolling and initialize them
  $.endlessPageInit = ->
    $('.endless_scrolling').each ->
      node = $(@)
      node.find('.pagination').hide()
      pagination = node.find('.pagination')[0]
      current_page = node.attr('current_page') * 1
      last_page = node.attr('last_page') * 1
      if current_page < last_page
        # Fire off new pages on scroll
        $(window).scroll ->
          current_page = node.attr('current_page') * 1
          if $(window).scrollTop() + $(window).height() >= $(document).height() - 40
            if current_page * 1 < last_page * 1
              $.endlessPageNext node unless node.hasClass 'busy'
            else
              $(window).unbind 'scroll'
        # Fire off the next page automatically if the window is bigger than the content
        if $('body').height() < $(window).height()
          $.endlessPageNext node unless node.hasClass 'busy'

) jQuery