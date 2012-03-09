$(document).ready ->

  $('body')
    .delegate '.more_activites', 'ajax:before', ->
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

    .delegate '.more_activites', 'ajax:error', (xhr, status, error) ->
      $(this).closest('.submit').removeClass('busy')
      $.alert { body: 'Error: unable to load recent activity.' }

    .delegate '.more_activites', 'ajax:success', (event, data, status, xhr) ->
      $(this).closest('.submit').removeClass('busy')
      lastLi = $('#body .activities li:last')
      if xhr.responseText
        $('#body .activities').append xhr.responseText
        lastLi.nextAll('li').hide().slideDown 600, 'swing'
        initialCount = $(this).attr('initial')*1
        incrementCount = $(this).attr('increment')*1
        baseCount = $('.activities li').length - initialCount
        while baseCount < incrementCount
          baseCount += incrementCount
        if baseCount % incrementCount
          $(this).closest('.submit').animate { opacity: 0 }, 300
      else
        submitNode = $(this).closest('.submit')
        $.alert {
          body: 'No more history available to display.'
          action: ->
            submitNode.animate { opacity: 0 }, 300
        }