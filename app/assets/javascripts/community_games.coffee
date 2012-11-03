jQuery(document).ready ($) ->
  $('#community_game_game_name').autocomplete
    source: $('#community_game_game_name').data('autocomplete-source')
