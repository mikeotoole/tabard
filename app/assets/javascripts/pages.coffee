jQuery(document).ready ($) ->
  
    $('body').addClass 'fluid'

    help = ->
        $.alert
            title: 'Wiki Editor Help'
            body: 'Visit Daring Fireball\'s <a target="_blank" href="http://daringfireball.net/projects/markdown/syntax">Markdown syntax</a> page for help using the Markdown markup language.'
    
    converter1 = Markdown.getSanitizingConverter()
    editor1 = new Markdown.Editor(converter1, "", { handler: help })
    
    editor1.hooks.set "insertImageDialog", (callback) ->
        $.prompt
            title: 'Insert Image'
            body: 'Paste a link to the image below:'
            actions:
                submit: (modal) -> callback(modal.$modal.find('.prompt').val())
        setTimeout ->
            $('#prompt').val('http://').focus()
        , 100
        true
    
    editor1.run()
    
    $('#wmd-button-bar .wmd-button').each ->
        $(@)
            .attr('meta', $(@).attr('title'))
            .removeAttr('title')