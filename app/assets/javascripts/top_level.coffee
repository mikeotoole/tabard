$(document).ready ->

  # make labels work like field suggestions
  $('#homebox form li.input input')
    .focus ->
      $(this).siblings('label').hide()
    .blur ->
      if $(this).val().length < 1
        $(this).siblings('label').show()
    .each ->
      if $(this).val().length < 1
        $(this).siblings('label').hide().show()
  
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
        link = $(this)
        $('#homebox .slideshownav a').removeClass 'current'
        link.addClass 'current'
        i = $('#homebox .slideshownav a').index($(this))
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
  
  # Enforce document scrolling
  $('.document .scroll')
    .wrapInner('<div class="pane" />')
    .css('height', 190)
    .bind 'scroll', ->
      boxH = $(this).height()
      paneH = $(this).find('.pane').height()
      if paneH <= boxH || $(this).scrollTop() >= paneH - boxH
        $(this)
          .closest('.document')
          .find('.accept')
          .css({ opacity: 1 })
          .find('input')
          .removeAttr('disabled')
          .find('+ label')
          .unbind 'click'
  $('.document:has(.scroll) .accept input[type="checkbox"]:not(:checked)')
    .attr('disabled', true)
    .closest('.accept')
    .css({ opacity: .5 })
  $('.document:has(.scroll) .accept label')
    .bind 'click', ->
      if $(this).closest('.accept').find('input:disabled')
        $.alert { body: "Make sure that you read and <b>scroll to the end</b> of each document before accepting the terms." }
        false
      else
        true
  $('.document .scroll').trigger 'scroll'