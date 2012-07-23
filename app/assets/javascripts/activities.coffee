jQuery(document).ready ($) ->

  $('body')
    .delegate '.more_activites', 'ajax:before', ->
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

    .delegate '.more_activites', 'ajax:error', (xhr, status, error) ->
      $(@).closest('.submit').removeClass('busy')
      $.alert { body: 'Error: unable to load recent activity.' }

    .delegate '.more_activites', 'ajax:success', (event, data, status, xhr) ->
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
        $.alert {
          body: 'No more history available to display.'
          action: ->
            submitNode.animate { opacity: 0 }, 300
        }