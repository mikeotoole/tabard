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
    $.confirm {
      title: 'Insert an Image'
      body: 'This needs to be connected to some sort of image uploader/manager component.'
      action: ->
        alert 'test'
    }
    true
    #
    # Old code saved for reference:
    #
    #  var prompt = "We have detected that you like cats. Do you want to insert an image of a cat?";
    #  if (confirm(prompt))
    #    callback("http://icanhascheezburger.files.wordpress.com/2007/06/schrodingers-lolcat1.jpg")
    #  else
    #    callback(null);
  
  editor1.run()