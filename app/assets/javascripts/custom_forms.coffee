$(document).ready ->

  # Drag and Drop sorting
  dragOpts = revert: 'invalid', cancel: '.toggle'
  dropOpts = accept: '.drag .container', tolerance: 'touch'

  $('form.custom_form')
    .delegate '.questions > li .toggle', 'click', ->
      container = $(@).closest('.container')
      qtitle = container.find('input.body').val()
      qtitle = '(no title)' unless qtitle
      container.find('> h3').html qtitle
      container.toggleClass('closed')
      if container.hasClass 'closed'
        container.draggable('enable')
      else
        container.draggable('disable')

    .delegate '.questions > li.drag .container', 'dragstart', (event, ui) ->
      return false unless $(@).hasClass 'closed'
      $('form.custom_form .questions > li.drop').remove()
      $('form.custom_form .questions > li.drag:first').before('<li class="drop">&nbsp;</li>')
      $('form.custom_form .questions > li.drag').after('<li class="drop">&nbsp;</li>')
      $('form.custom_form .questions > li.drop').droppable(dropOpts)
      $(@).closest('.drag').prevAll('.drop').first().remove()
      $(@).closest('.drag').nextAll('.drop').first().remove()

    .delegate '.questions > li.drag .container', 'dragstop', (event, ui) ->
      $('form.custom_form .questions > li.drop').remove()
      $('form.custom_form .questions > li.drag .container').stop().animate opacity: 1, 200

    .delegate '.questions > li.drop', 'drop', (event, ui) ->
      dragLi = ui.draggable.closest('li')
      html = ui.draggable.html()
      $('form.custom_form .questions > li.drag .container').stop().animate opacity: 1, 200
      $(@)
        .html('<div class="container">'+html+'</div>')
        .removeClass('drop dropover')
        .addClass('drag')
        .css height: ''
      $('form.custom_form .questions > li.drop').remove()
      newClassNames = 'closed'
      if ui.draggable.hasClass('question_with_errors')
        newClassNames += ' question_with_errors'
      $(@)
        .attr({ question: dragLi.attr('question'), question_id: dragLi.attr('question_id'), question_style: dragLi.attr('question_style') })
        .droppable('destroy')
        .find('.container')
        .addClass(newClassNames)
        .draggable(dragOpts)
        .trigger('init')
      ui.draggable.closest('li').remove()
      positionNumber = 0
      $('form.custom_form .questions input.position').each ->
        $(@).val ++positionNumber
    
    .delegate '.questions > li.drop', 'dropover', (event, ui) ->
      $(@).addClass('dropover')
      
    .delegate '.questions > li.drop', 'dropout', (event, ui) ->
      $(@).removeClass('dropover')

  $('form.custom_form .questions > li.drag .container')
    .draggable(dragOpts)
  $('form.custom_form .questions > li.drag .container:not(.closed)')
    .draggable('disable')
  
  
  # Q&A Functionality
  
  $('form.custom_form')
    .delegate '.questions > li .container', 'init', ->
      container = $(@)
      qli = container.closest('li')
      right = qli.find('.right')
    
      # Remove question link
      container
        .append('<a class="remove">Remove Question</a>')
        .find('>.remove')
        .click ->
          if qli.filter('[question_id]').length
            question = '<input name="custom_form[questions_attributes]['+qli.attr('question')+'][_destroy]" type="hidden" value="true">'
            qli.slideUp 400, ->
              qli.replaceWith(question)
          else
            qli.slideUp 400, ->
              qli.remove()
      
      # TypeStyle select change action
      container.delegate 'input', 'change', ->
        select = $(@).closest('.select')
        answers = right.find('.answers')
        checkedInput = select.find('input:checked')
        val = checkedInput.val()
        select.find('input').removeAttr 'checked'
        checkedInput.attr 'checked','checked'
        if val.match /short_answer_question|long_answer_question/i
          right.addClass('hidden')
          answers.find('input')
            .attr('disabled',true)
            .attr('readonly',true)
        else
          right.removeClass('hidden')
          answers.find('input')
            .removeAttr('disabled readonly')
          if answers.find('li').size() == 0
            right.find('.add a').trigger 'click'
        selectUl = select.find('ul')
        selectUl.animate opacity: 0, 200, ->
          selectUl
            .hide()
            .animate opacity: 0, 5, ->
              selectUl.show().css opacity: 1
      
      # Add answer link
      right.find('p.add').removeClass('hidden')
      
      # Remove answer link
      right.find('.answers').delegate 'li a.remove', 'click', ->
        ali = $(@).closest('li')
        ali.slideUp 400, ->
          if ali.attr 'question'
            answer = '<input name="custom_form[questions_attributes]['+ali.attr('question')+'][predefined_answers_attributes]['+ali.attr('answer')+'][_destroy]" type="hidden" value="true">'
            $(@).replaceWith(answer)
      
      qli.find('.select input:checked').trigger 'change'
      
  $('form.custom_form .questions > li .container').trigger 'init'