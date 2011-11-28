$(document).ready ->
  
  $('body').addClass 'fluid'

  help = ->
    $.alert {
      title: 'Wiki Editor Help'
      body: 'Visit Daring Fireball\'s <a target="_blank" href="http://daringfireball.net/projects/markdown/syntax">Markdown syntax</a> page for help using the Markdown markup language.'
    }
  
  converter1 = Markdown.getSanitizingConverter()
  editor1 = new Markdown.Editor(converter1, "", { handler: help })
  
  editor1.hooks.set "insertImageDialog", (callback) ->
    $.prompt {
      body: 'Place a link to the image below:'
      action: (link) ->
        callback(link)
    }
    true
  
  editor1.run()