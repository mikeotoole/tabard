//= require jquery.ui.draggable
//= require jquery.ui.droppable

$(document).ready ->

  # Drag and Drop sorting
  dragOpts = { revert: 'invalid', cancel: '.toggle' }
  dropOpts = { accept: '.drag .container', tolerance: 'touch' }

  $('form.custom_form')
    .delegate '.questions > li .toggle', 'click', ->
      container = $(this).closest('.container')
      qtitle = container.find('input').val()
      qtitle = '(no title)' unless qtitle
      container.find('> h3').html qtitle
      container.toggleClass('closed')
      if container.hasClass 'closed'
        container.draggable('enable')
      else
        container.draggable('disable')

    .delegate '.questions > li.drag .container', 'dragstart', (event, ui) ->
      return false unless $(this).hasClass 'closed'
      $('form.custom_form .questions > li.drop').remove()
      $('form.custom_form .questions > li.drag:first').before('<li class="drop">&nbsp;</li>')
      $('form.custom_form .questions > li.drag').after('<li class="drop">&nbsp;</li>')
      $('form.custom_form .questions > li.drop').droppable(dropOpts)
      $(this).closest('.drag').prevAll('.drop').first().remove()
      $(this).closest('.drag').nextAll('.drop').first().remove()

    .delegate '.questions > li.drag .container', 'dragstop', (event, ui) ->
      $('form.custom_form .questions > li.drop').remove()
      $('form.custom_form .questions > li.drag .container').stop().animate({ opacity: 1 }, 200)

    .delegate '.questions > li.drop', 'drop', (event, ui) ->
      html = ui.draggable.html()
      $('form.custom_form .questions > li.drag .container').stop().animate({ opacity: 1 }, 200)
      $(this)
        .html('<div class="container">'+html+'</div>')
        .removeClass('drop dropover')
        .css({ height: '' })
        .addClass('drag')
      $('form.custom_form .questions > li.drop').remove()
      ui.draggable.closest('li').remove()
      $(this)
        .droppable('destroy')
        .find('.container')
        .addClass('closed')
        .draggable(dragOpts)
        .trigger('init')
    
    .delegate '.questions > li.drop', 'dropover', (event, ui) ->
      $(this).addClass('dropover')
      
    .delegate '.questions > li.drop', 'dropout', (event, ui) ->
      $(this).removeClass('dropover')

  $('form.custom_form .questions > li.drag .container')
    .draggable(dragOpts)
  
  
  # Q&A Functionality
  
  $('form.custom_form')
    .delegate '.questions > li .container', 'init', ->
      li = $(this)
      right = $(this).find('.right')
      li.data('qstyle',li.attr('question_style'))
      if $(this).find('>a.remove').size() == 0
        # Remove question link
        li
          .append('<a class="remove">Remove Question</a>')
          .find('>.remove')
          .click ->
            if li.filter('[question_id]').length
              question = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][_destroy]" type="hidden" value="true">'
              qid = li.attr 'question_id'
              q = '<input name="custom_form[questions_attributes]['+li.attr('question')+'][id]" type="hidden" value="'+qid+'">'
              li.slideUp 400, ->
                $(this).replaceWith(question + q)
            else
              li.slideUp 400, ->
                $(this).remove()
        
        # TypeStyle select change action
        li
          .find('.select input')
          .change ->
            select = $(this).closest('.select')
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
        
        # Add answer link
        right.find('p.add').removeClass('hidden')
        
        # Remove answer link
        right.find('.answers').delegate 'li a.remove', 'click', ->
          ali = $(this).closest('li')
          ali.slideUp 400, ->
            if ali.attr 'question'
              answer = '<input name="custom_form[questions_attributes]['+ali.attr('question')+'][predefined_answers_attributes]['+ali.attr('answer')+'][_destroy]" type="hidden" value="true">'
              $(this).replaceWith(answer)
      
      li.find('.select input:checked').trigger 'change'
      
  $('form.custom_form .questions > li .container').trigger 'init'