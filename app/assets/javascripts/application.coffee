//= require jquery
//= require jquery_ujs

(($) ->

  # alert box
  $.alert = (options) ->
    title = options['title'] or= ''
    body = options['body'] or= ''
    button = options['button'] or= 'Ok'
    $('body').append('<div id="mask"></div><div id="modal" class="alert"><div class="actions"><button>' + button + '</button></div></div>')
    $('#modal').prepend('<p>' + body + '</p>') if body
    $('#modal').prepend('<h1>' + title + '</h1>') if title
    $('#mask')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#modal button').click ->
      $('#modal').animate { marginTop: 0, opacity: 0 }, 300
      $('#mask').animate { opacity: 0 }, 600, ->
        $('#mask, #modal').remove()
        
  # confirm box
  $.confirm = (options) ->
    title = options['title'] or= ''
    body = options['body'] or= ''
    cancel = options['cancel'] or= 'Cancel'
    affirm = options['affirm'] or= 'Continue'
    action = options['action']
    $('body').append('<div id="mask"></div><div id="modal" class="confirm"><h1>' + title + '</h1><p>' + body + '</p><div class="actions"><button class="cancel">' + cancel + '</button><button class="affirm">' + affirm + '</button></div></div>')
    $('#mask')
      .css({ opacity: 0 })
      .animate({ opacity: .7 }, 400, 'linear')
    $('#modal')
      .css({ opacity: 0, marginLeft: -500 })
      .animate({ opacity: 1, marginLeft: -250 }, 200)
    $('#modal button.cancel').click ->
      $('#modal').animate { marginTop: 0, opacity: 0 }, 300
      $('#mask').animate { opacity: 0 }, 600, ->
        $('#mask, #modal').remove()
    $('#modal button.affirm')
      .bind 'click', action
      .bind 'click', ->
        $('#modal button.cancel').trigger 'click'
        
) jQuery

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
  
  # override rails allow action (for data-confirm)
  $.rails.allowAction = (element) ->
    message = element.data("confirm")
    return true unless message
    if element.data('affirm') == yes
      if $.rails.fire(element, "confirm")
        $.rails.fire(element, "confirm:complete", [ true ])
    else
      $.confirm
        body: element.data 'confirm'
        action: ->
          element.data 'affirm', yes
          element.click()
          $('#modal button.cancel').trigger 'click'
      false