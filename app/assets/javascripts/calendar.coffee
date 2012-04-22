$(document).ready ->

  $(window)
    .on 'scroll', ->
      $('#calendar.week dl')
        .css({ top: -$(this).scrollTop() })
        .filter('.times')
        .css({ top: -$(this).scrollTop()*2 })
    .trigger 'scroll'

  $('#calendar.week dd')
    .on 'mouseenter', ->
      $('#calendar.week dl.times dd:nth-child(' + ($(this).index()+1) + ')').addClass 'hover'
    .on 'mouseleave', ->
      $('#calendar.week dl.times dd').removeClass 'hover'