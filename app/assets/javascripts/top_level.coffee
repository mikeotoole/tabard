$(document).ready ->

  # make labels work like field suggestions
  $('#homebox form li.input')
    .delegate 'input', 'focus', ->
      $(@).siblings('label').hide()
    .delegate 'input', 'blur change', ->
      if $(@).val().length < 1
        $(@).siblings('label').show()
      else
        $(@).siblings('label').hide()
    .each ->
      input = $(@).find('input')
      if input.val().length < 1
        input.siblings('label').hide().show()
      setTimeout ->
        input.trigger 'change'
      ,100
  
  # hope page slide show
  numberOfSlides = $('#homebox .slideshow img').length
  if numberOfSlides > 0
    slideTimeout = ''
    timeBetweenSlides = 6000
    $('#homebox .slideshow').after '<div class="slideshownav"></div>'
    $('#homebox .slideshownav').append('<a href="javascript:;"></a>') for i in [1..numberOfSlides]
    firstSlide = Math.floor Math.random() * numberOfSlides
    $('#homebox .slideshow dt')
      .removeClass('current')
      .eq(firstSlide)
      .addClass 'current'
    $('#homebox .slideshownav a')
      .click ->
        clearTimeout slideTimeout
        link = $(@)
        $('#homebox .slideshownav a').removeClass 'current'
        link.addClass 'current'
        i = $('#homebox .slideshownav a').index($(@))
        $('#homebox .slideshow dt').removeClass 'current'
        $('#homebox .slideshow dt:eq('+i+')').addClass 'current'
        slideTimeout = setTimeout ->
          if link.next().length
            link.next().click()
          else
            $('#homebox .slideshownav a:first').click()
        , timeBetweenSlides
      .eq(firstSlide).addClass 'current'
    slideTimeout = setTimeout ->
      link = $('#homebox .slideshownav a').eq(firstSlide)
      if link.next().length
        link.next().click()
      else
        $('#homebox .slideshownav a:first').click()
    , timeBetweenSlides
  
  # videobox player
  $('#videobox .menu a').click ->
    link = $(@).attr('href').split /v=/
    $('#videobox .player iframe').attr 'src', 'http://www.youtube.com/embed/'+link[1]+'?wmode=transparent'
    $('#videobox .menu li').removeClass 'current'
    $(@).closest('li').addClass 'current'
    false
  $('#videobox .menu li:first').addClass('current').find('a').trigger 'click'
  $('.videolink').click ->
    link = $(@).attr('href')
    videos = $('#videobox .menu a')
    for video in videos
      if $(video).attr('href') == link
        $('html, body').animate { scrollTop: 0 }, 500
        $(video).trigger 'click'
        return false
  
  # Enforce document scrolling
  $('.document .scroll')
    .wrapInner('<div class="pane" />')
    .css('height', 190)
    .bind 'scroll', ->
      boxH = $(@).height()
      paneH = $(@).find('.pane').height()
      if paneH <= boxH || $(@).scrollTop() >= paneH - boxH
        $(@)
          .closest('.document')
          .find('.accept')
          .css({ opacity: 1 })
          .find('input')
          .removeAttr('disabled')
          .find('+ label')
          .unbind('click')
  $('.document:has(.scroll) .accept input[type="checkbox"]:not(:checked)')
    .attr('disabled', true)
    .closest('.accept')
    .css({ opacity: .5 })
    .closest('.document')
    .after('<dfn class="hint">Scroll before accepting</dfn>')
  $('.document:has(.scroll) .accept label')
    .bind 'click', ->
      if $(@).closest('.accept').find('input:disabled')
        $.alert { body: "Make sure that you read and <b>scroll to the end</b> of each document before accepting the terms." }
        false
      else
        true
  $('.document .scroll').trigger 'scroll'