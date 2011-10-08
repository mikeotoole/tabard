$(document).ready ->
  
  $('.comments textarea')
    .bind 'keypress change blur', (e) ->
      if $.trim($(this).val()) == ''
        $(this).removeClass 'open'
      else
        $(this).addClass 'open'
        
  $('.comments .reply')
    .data('type', 'html')
    
    .bind 'ajax:success', (event, data, status, xhr) ->
      alert(data)
      # $(this).after(data)
    
    .bind 'ajax:error', (xhr, status, error) ->
      alert error
  
  $('.comments form')
    .data('type', 'html')
    
    .bind 'ajax:beforeSend', () ->
      $(this)
        .addClass('busy')
        .prop('disabled', true)
        
    .bind 'ajax:success', (event, data, status, xhr) ->
      $(this)
        .removeClass('busy')
        .find('textarea')
        .val('')
        .removeClass('open')
        .removeProp('disabled')
      $(this)
        .parents('.comments')
        .find('ol:first')
        .append(data)
        .find('li:last')
        .css({ opacity: 0 })
        .animate({ opacity: 1 }, 500)
      $(this)
        .find('textarea')
        .blur()
    
    .bind 'ajax:error', (xhr, status, error) ->
      $(this)
        .removeClass('busy')
        .find('textarea')
        .removeProp('disabled')
      #TODO Doug - needs user-friendly error handling
      alert error
      $(this)
        .find('textarea')
        .focus()
  
 # $('.comments form')
 #   .bind 'submit', () ->
 #     $.ajax() ->
 #       url: $(this).attr('action')
 #       type: $(this).attr('method')
 #       dataType: 'html'
 #       data:
 #         commentable_type: 'Discussion'
 #         commentable_id:
 #       beforeSend: () ->
 #         $(this)
 #           .addClass('busy')
 #           .prop('disabled', true)
 #         false
 #       complete: () ->
 #         false
 #       success: (event, data, status, xhr) ->
 #         $(this)
 #           .removeClass('busy')
 #           .find('textarea')
 #           .val('')
 #           .removeClass('open')
 #           .removeProp('disabled')
 #         $(this)
 #           .parents('.comments')
 #           .find('ol:first')
 #           .append(data)
 #           .find('li:last')
 #           .css({ opacity: 0 })
 #           .animate({ opacity: 1 }, 500)
 #         $(this)
 #           .find('textarea')
 #           .blur()
 #         false
 #       error: (xhr, status, error) ->
 #         $(this)
 #           .removeClass('busy')
 #           .find('textarea')
 #           .removeProp('disabled')
 #         #TODO Doug - needs user-friendly error handling
 #         alert error
 #         $(this)
 #           .find('textarea')
 #           .focus()
 #         false
 #       false
 #     false

  false