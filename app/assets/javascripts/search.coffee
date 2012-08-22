jQuery(document).ready ($) ->

  cache = []
  
  $('#search').autocomplete
    autoFocus: true
    delay: 300
    minLength: 2
    open: (e, ui) ->
      $(@).autocomplete('widget').width $(@).width() + 10
    position:
      my: 'left top'
      at: 'left bottom'
      offset: '-1, -3'
      collision: 'none'
    select: (e, ui) ->
      window.location = ui.item.url
    source: (request, response) ->
      term = request.term
      return response cache[term] if cache[term]?
      lastXhr = $.getJSON $('#search').data('url'), request, (data, status, xhr) ->
        cache[term] = data
        response data if xhr is lastXhr
        results = $.parseJSON xhr.responseText