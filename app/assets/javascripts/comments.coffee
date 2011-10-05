$(document).ready ->
  
  # detect comment and leave box open
  $('.comments textarea')
    .bind 'keypress change blur', (e) ->
      if $.trim($(this).val()) == ''
        $(this).removeClass('open')
      else
        $(this).addClass('open')
  
  false