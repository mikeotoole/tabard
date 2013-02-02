jQuery(document).ready ($) ->

    cache = []
    $form = $('#new_community_game')
    $fields = $form.find '.gamefields'
    $fields.detach().removeClass 'hide'

    $('#community_game_game_name').autocomplete
        autoFocus: false
        delay: 300
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
            $fields.detach()
            $fields.filter("[data-game-type='#{ui.item.type}']").insertAfter $('#game_name')
        source: (request, response) ->
            term = request.term
            return response cache[term] if cache[term]?
            lastXhr = $.getJSON $('#community_game_game_name').data('autocomplete-source'), request, (data, status, xhr) ->
                cache[term] = data
                response data if xhr is lastXhr