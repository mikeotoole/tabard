jQuery(document).ready ($) ->

  cache = []

  $('#community_game_game_name').autocomplete
    autoFocus: false
    delay: 300
    focus: (e, ui) ->
      $(@).val ui.item.display_name
      return false
    minLength: 2
    open: (e, ui) ->
      $(@).autocomplete('widget').width $(@).width() + 8
    position:
      my: 'left top'
      at: 'left bottom'
      offset: '0, -3'
      collision: 'none'
    select: (e, ui) ->
      $(@).val ''
      console.log 'do something'
    source: (request, response) ->
      term = request.term
      return response cache[term] if cache[term]?
      lastXhr = $.getJSON $('#community_game_game_name').data('autocomplete-source'), request, (data, status, xhr) ->
        cache[term] = data
        response data if xhr is lastXhr