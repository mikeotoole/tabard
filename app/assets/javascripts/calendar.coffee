$(document).ready ->

  $(window)
    .on 'scroll', ->
      $('#calendar.week dl')
        .css({ top: -$(@).scrollTop() })
        .filter('.times')
        .css({ top: -$(@).scrollTop()*2 })
    .trigger 'scroll'

  $('#calendar.week dd')
    .on 'mouseenter', ->
      $('#calendar.week dl.times dd:nth-child(' + ($(@).index()+1) + ')').addClass 'hover'
    .on 'mouseleave', ->
      $('#calendar.week dl.times dd').removeClass 'hover'