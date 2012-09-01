jQuery(document).ready ($) ->

  # home page slide show
  slideshowPauseTime = 6000
  slideshowTimeout = null
  
  navEl = $('<div class="nav">').appendTo '#homebox .slideshow'
  $('<a>').appendTo(navEl).data 'slide', li for li in $('#homebox .slideshow li')
  navEl.find('a:first').addClass 'current'

  $('#homebox .slideshow')
    .on 'click', '.nav a', ->
      data = $(@).data()
      
      clearTimeout slideshowTimeout if slideshowTimeout
      $('#homebox .slideshow').find('li, .nav a').removeClass 'current'
      $(@).addClass 'current'
      $(data.slide).addClass 'current'
      
      slideshowTimeout = setTimeout ->
        next = navEl.find('a.current').next 'a'
        next = navEl.find('a:first') unless next.length
        next.trigger 'click'
      , slideshowPauseTime

  navEl.find('a:first').trigger('click');