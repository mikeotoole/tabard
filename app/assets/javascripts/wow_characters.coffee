$(document).ready ->

  $('#wow_character_race').parent().hide()
  races = $('#wow_character_race').html()
  $('#wow_character_char_class').change ->
    char_class = $('#wow_character_char_class :selected').text()
    escaped_char_class = char_class.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(races).filter("optgroup[label='#{escaped_char_class}']").html()
    if options
      $('#wow_character_race').html(options)
      $('#wow_character_race').parent().show()
    else
      $('#wow_character_race').empty()
      $('#wow_character_race').parent().hide()