$(document).ready ->

  $('#swtor_character_species').parent().hide()
  species = $('#swtor_character_species').html()
  $('#swtor_character_char_class').change ->
    char_class = $('#swtor_character_char_class :selected').text()
    escaped_char_class = char_class.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(species).filter("optgroup[label='#{escaped_char_class}']").html()
    if options
      $('#swtor_character_species').html(options)
      $('#swtor_character_species').parent().show()
    else
      $('#swtor_character_species').empty()
      $('#swtor_character_species').parent().hide()