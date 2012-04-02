$(document).ready ->

  $(window)
    .on 'scroll', ->
      $('#calendar.week dl')
        .css({ top: -$(this).scrollTop() })
        .filter('.times')
        .css({ top: -$(this).scrollTop()*2 })
    .trigger 'scroll'
    setInterval ->
      $(window).trigger 'scroll'
    , 500

  $('#calendar.week dd')
    .on 'mouseover', ->
      id = $(this).index() + 1
      $('#calendar.week dd:nth-child('+id+')').addClass 'hover'
    .on 'mouseout', ->
      id = $(this).index() + 1
      $('#calendar.week dd:nth-child('+id+')').removeClass 'hover'