jQuery(document).ready ($) ->
  $('#played_game_game_name').autocomplete
    source: $('#played_game_game_name').data('autocomplete-source')
