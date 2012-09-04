jQuery(document).ready ($) ->

  # Adjust body and content heights dynamically
  $('#body')
    .on 'DOMNodeInserted', ->
      bodyPadTop = parseInt $('#body').css 'padding-top'
      bodyPadBottom = parseInt $('#body').css 'padding-bottom'
      diffOffset = $('#body').offset().top - $('#content').offset().top
      $('#content').height $('#body').height() + bodyPadTop + bodyPadBottom + diffOffset
    .trigger 'DOMNodeInserted'
  
  # videobox player
  #$('#videobox .menu a').click ->
  #  link = $(@).attr('href').split /v=/
  #  $('#videobox .player iframe').attr 'src', 'http://www.youtube.com/embed/'+link[1]+'?wmode=transparent'
  #  $('#videobox .menu li').removeClass 'current'
  #  $(@).closest('li').addClass 'current'
  #  false
  #$('#videobox .menu li:first').addClass('current').find('a').trigger 'click'
  #$('.videolink').click ->
  #  link = $(@).attr('href')
  #  videos = $('#videobox .menu a')
  #  for video in videos
  #    if $(video).attr('href') == link
  #      $('html, body').animate { scrollTop: 0 }, 500
  #      $(video).trigger 'click'
  #      return false