jQuery(document).ready ($) ->

  $('#recruit_email').autocomplete
    autoFocus: true
    delay: 300
    minLength: 2
    open: ->
      $(@).autocomplete('widget').width $(@).width() + 8
    position:
      my: 'left top'
      at: 'left bottom'
      offset: '0, -3'
      collision: 'none'
    source: [
      'acai'
      'accredit'
      'ace'
      'acorn'
      'action'
      'actor'
      'actress'
      'zoo'
    ]