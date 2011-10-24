//= require jquery
//= require jquery_ujs

(($) ->
  # alert box
  $.alert = (t1,t2='',t3='') ->
    $('body').append('<div id="mask"></div><div id="modal" class="alert"></div>')
    if t3
      $('#modal').append('<h1>' + t1 + '</h1><p>' + t2 + '</p><div class="actions"><button>' + t3 + '</button></div>')
    else
      $('#modal').append('<p>' + t1 + '</p><div class="actions"><button>' + (t2 or= 'Ok') + '</button></div>')
    $('#mask')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#modal button')
      .click ->
        $('#modal').animate { marginTop: 0, opacity: 0 }, 300
        $('#mask').animate { opacity: 0 }, 600, ->
          remove()
) jQuery

# confirm box

$(document).ready ->
  
  $.alert 'Holy Smokes!', 'Lorem ipsum dolor sit amet.', 'Awesome!'
  
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