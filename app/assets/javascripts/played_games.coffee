jQuery(document).ready ($) ->

    cache = []

    $('#played_game_game_name').autocomplete
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
        source: $('#played_game_game_name').data 'autocomplete-source'