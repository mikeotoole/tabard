class window.Skylite

  constructor: (options) ->
    @[key] = option for key, option of options

    @$modal = $("<div class='modal #{@type}'>")
    $("<h1>#{@title}</h1>").appendTo @$modal if @title?
    $("<p>#{@body}</p>").appendTo @$modal if @body?
    @$actions = $("<div class='actions'>")

    # Add action butons
    if @actions?
      $.each @actions, (text, action) =>
        $("<button>")
          .text(text)
          .addClass(text.toLowerCase().replace(/[^a-z]/g,''))
          .click(=> action(@); @dismiss())
          .appendTo @$actions
    else
      $("<button>")
        .text('Okay')
        .addClass('ok')
        .click(=> @dismiss())
        .appendTo @$actions

    # Add a hotkey to auto-click the last action on press(enter) on a delay
    setTimeout =>
      $(document).on 'keyup', (e) =>
        return unless @$modal.is ':last-of-type'
        key = e.keyCode ? e.which
        if key is 13 # Enter
          @$actions.find('button:last').trigger 'click'
          $(document).off 'keypress', false, @keypress
        if key is 27 # Esc
          @dismiss()
          $(document).off 'keypress', false, @keypress
      , @keypress
    , 500

    @$actions.appendTo @$modal
    @render()

  mask: ->
    if $('.wmd-prompt-background').length
      $('#mask').remove()
    else if $('#mask').length is 0
      $('body').append('<div id="mask"></div>')
    $('#mask, .wmd-prompt-background')
      .css(opacity: 0)
      .animate({ opacity: .7 }, 400, 'linear')
      .click (-> $('body > .modal, .wmd-prompt-dialog').find('.cancel').trigger 'click')

  unmask: ->
    $('#mask, .wmd-prompt-background').stop(true).fadeTo 200, 0, -> $(@).remove()

  render: ->
    @mask()
    @$modal
      .css(opacity: 0, marginLeft: -@width)
      .appendTo('body')
      .animate {opacity: 1, marginLeft: Math.round(@width/-2)}, 200

  dismiss: ->
    @unmask() if $('body > .modal').length is 1
    @$modal.animate {marginTop: 0, opacity: 0}, 300, =>
      if @callback?
        $modal = @$modal
        @callback()
      @$modal.remove()