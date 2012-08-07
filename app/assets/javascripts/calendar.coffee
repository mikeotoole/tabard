jQuery(document).ready ($) ->

  $('#calendar.week dd')
    .on 'mouseenter', ->
      $("#calendar.week dl dd:nth-child(#{$(@).index()+1})").addClass 'hover'
    .on 'mouseleave', ->
      $('#calendar.week dd').removeClass 'hover'

  # Handle date collisions within each day
  colW = 152
  $('#calendar.week dl.day').each ->
    events = $(@).find 'dd a'
    $(event).data 'col', 1 for event in events
    return unless events.length > 1
    for event1, e1Idx in events
      for event2 in events.slice e1Idx + 1
        break if $(event2).data('start-hour') >= $(event1).data('end-hour') or $(event1).data('col') != $(event2).data('col')
        col = $(event1).data('col') + 1
        $(event2)
          .data('col', col)
          .css left: colW * (col-1) + 3
        $(@).css width: colW * col + 3

  # Handle dragging
  offsetX1 = 60 # Left edge
  offsetX2 = 55 # Inner left padding
  offsetX = offsetX1 + offsetX2
  offsetY = 70
  
  $('#calendar.week .pane').draggable
    containment: [offsetX, offsetY, offsetX, offsetY]
    scroll: false
  
  $(window).resize ->
    availW = $('#calendar.week').width() - offsetX2
    availH = $('#calendar.week').height()
    paneW = $('#calendar.week .pane').width()
    paneH = $('#calendar.week .pane').height()
    if availW >= paneW + offsetX2
      x1 = x2 = offsetX
    else
      x1 = availW - paneW + offsetX2
      x2 = offsetX
    if availH >= paneH
      y1 = y2 = offsetY
    else
      y1 = availH - paneH + offsetY
      y2 = offsetY
    if x1 isnt x2 or y1 isnt y2
      $('#calendar.week .pane').addClass 'grab'
    else
      $('#calendar.week .pane').removeClass 'grab'
    $('#calendar.week .pane')
      .css(left: offsetX2, top: 0)
      .draggable 'option', 'containment', [x1, y1, x2, y2]
  $(window).trigger 'resize'