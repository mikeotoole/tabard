jQuery(document).ready ($) ->

  $('body')
    .on 'ajax:before', '.more_activites', ->
      $(@).closest('.submit').addClass('busy')
      updatedBefore = $('#body ol.activities li:last').attr 'created_at'
      if updatedBefore
        if $(@).data 'original-params'
          params = $(@).data 'original-params'
        else
          params = $(@).data 'params'
          $(@).data 'original-params', params
        params = '' unless params
        $(@).data 'params', params + '&updated[before]=' + updatedBefore

    .on 'ajax:error', '.more_activites', (xhr, status, error) ->
      $(@).closest('.submit').removeClass('busy')
      $.alert 'Error: unable to load recent activity.'

    .on 'ajax:success', '.more_activites', (event, data, status, xhr) ->
      $(@).closest('.submit').removeClass('busy')
      lastLi = $('#body ol.activities li:last')
      if xhr.responseText
        $('#body ol.activities').append xhr.responseText
        lastLi.nextAll('li').hide().slideDown 600, 'swing'
        initialCount = $(@).attr('initial')*1
        incrementCount = $(@).attr('increment')*1
        baseCount = $('#body ol.activities li').length - initialCount
        while baseCount < incrementCount
          baseCount += incrementCount
        if baseCount % incrementCount
          $(@).closest('.submit').animate { opacity: 0 }, 300
      else
        submitNode = $(@).closest('.submit')
        $.alert
          body: 'No more history available to display.'
          actions:
            ok: -> submitNode.animate { opacity: 0 }, 300