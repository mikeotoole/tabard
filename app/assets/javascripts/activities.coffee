$(document).ready ->

  $('.more_activites')
    .bind 'ajax:before', ->
      $(this).closest('.submit').addClass('busy')
      updatedBefore = $('.activities li:last').attr 'created_at'
      if updatedBefore
        if $(this).data 'original-params'
          params = $(this).data 'original-params'
        else
          params = $(this).data 'params'
          $(this).data 'original-params', params
        params = '' unless params
        $(this).data 'params', params + '&updated[before]=' + updatedBefore
    .bind 'ajax:error', (xhr, status, error) ->
      $(this).closest('.submit').removeClass('busy')
      $.alert { body: 'Error: unable to load recent activity.' }
    .bind 'ajax:success', (event, data, status, xhr) ->
      $(this).closest('.submit').removeClass('busy')
      lastLi = $('.activities li:last')
      $('.activities').append xhr.responseText
      lastLi.nextAll('li').hide().slideDown 500, 'swing'