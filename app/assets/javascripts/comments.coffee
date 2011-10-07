$(document).ready ->
  
  # detect comment and leave box open
  $('.comments textarea')
    .bind 'keypress change blur', (e) ->
      if $.trim($(this).val()) == ''
        $(this).removeClass 'open'
      else
        $(this).addClass 'open'
        
  $('.comments .reply')
    .bind 'click', () ->
      $.ajax() ->
        url: $(this).attr('href')
        dataType: 'html'
        success: (event, data, status, xhr) ->
          alert 'success'
        error: (xhr, status, error) ->
          alert 'fail'
      false
  
  # show loading image while request is made
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
        .focus()
    
    .bind 'ajax:error', (xhr, status, error) ->
      $(this)
        .removeClass('busy')
        .find('textarea')
        .removeProp('disabled')
      #TODO Doug - needs user-friendly error debindry
      alert error
      $(this)
        .find('textarea')
        .focus()

  false