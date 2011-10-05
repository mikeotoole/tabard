//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready ->
  
  # text box suggest
  $('form input').each ->
    $(this).data 'default', $(this).attr 'title'
    $(this).removeAttr 'title'
    $(this).focus ->
      if $.trim($(this).attr 'value') is $(this).data('default')
        $(this).val ''
    $(this).blur ->
      if $.trim($(this).attr 'value') is ''
        $(this).val $(this).data 'default'
    $(this).trigger 'blur'
  
  # detect comment and leave box open
  $('.comments textarea')
    .bind 'keypress change', (e) ->
      if $.trim($(this).val()) == ''
        $(this).removeClass('open')
      else
        $(this).addClass('open')
  
  false