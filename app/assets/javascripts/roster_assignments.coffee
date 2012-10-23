jQuery(document).ready ($) ->

  $characters = $('.select.characters')
  $games = $('.select.games')
  $games.hide()

  # filter out characters that do not have games to match up to
  $characters.find('li').hide()
  for li in $games.find 'li'
    gameType = $(li).attr 'data-game-type'
    $characters.find("li[data-game-type=#{gameType}]").show()

  # Filter game choices when a character is selected
  $characters.on 'change', 'input', ->
    gameType = $characters.find('li:has(input:checked)').attr 'data-game-type'
    $games.find('li').hide()
    $matches = $games.find("li[data-game-type=#{gameType}]")
    if $matches.length >= 1
      $games.show()
      $matches.show()
      $matches.find('input').attr 'checked', true if $matches.length is 1