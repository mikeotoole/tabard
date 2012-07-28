jQuery(document).ready ($) ->

  window.qDragOpts =
    cancel: '.toggle'
    revert: 'invalid'
    scope: 'questions'
    start: (evt, ui) ->
      return unless $(@).hasClass 'closed'
      questions = $('form.custom_form .questions')
      questions.find('> li.drop').remove()
      questions.find('> li.drag:first').before '<li class="drop">&nbsp;</li>'
      questions.find('> li.drag').after '<li class="drop">&nbsp;</li>'
      questions.find('> li.drop').droppable qDropOpts
      $(@).closest('.drag').prevAll('.drop').first().remove()
      $(@).closest('.drag').nextAll('.drop').first().remove()
    stop: (evt, ui) ->
      $('form.custom_form .questions > li.drop').remove()
      $('form.custom_form .questions > li.drag .container').stop().animate opacity: 1, 200

  window.qDropOpts =
    hoverClass: 'dropover'
    scope: 'questions'
    tolerance: 'touch'
    drop: (evt, ui) ->
      $('form.custom_form .questions > li.drag .container').stop().animate opacity: 1, 200
      dragEl = ui.draggable.closest 'li'
      $q = ui.draggable.clone()
      $q.attr style: '', class: 'container closed ui-draggable'
      $(@)
        .html($q)
        .removeClass('drop dropover')
        .addClass('drag')
        .css left: '', top: '', opacity: ''
      $('form.custom_form .questions > li.drop').remove()
      newClassNames = 'closed'
      newClassNames += ' question_with_errors' if ui.draggable.hasClass 'question_with_errors'
      $(@)
        .attr({ question: dragEl.attr('question'), question_id: dragEl.attr('question_id'), question_style: dragEl.attr('question_style') })
        .droppable('destroy')
        .find('.container')
        .addClass(newClassNames)
        .draggable(qDragOpts)
        .trigger 'init'
      positionNumber = 0
      $('form.custom_form .questions input.position').each -> $(@).val ++positionNumber
      parentEl = ui.draggable.closest 'li'
      ui.draggable.remove()
      parentEl.remove()

  $('form.custom_form').on 'click', '.questions > li .toggle', ->
    container = $(@).closest('.container')
    qtitle = container.find('input.body').val()
    qtitle = '(no title)' unless qtitle
    container.find('> h3').html qtitle
    container.toggleClass 'closed'
    if container.hasClass 'closed'
      container.draggable 'enable'
    else
      container.draggable 'disable'

  $('form.custom_form .questions > li.drag .container').draggable qDragOpts
  $('form.custom_form .questions > li.drag .container:not(.closed)').draggable 'disable'
  
  
  # Q&A Functionality
  $('form.custom_form').on 'init', '.questions > li .container', ->
    qEl = $(@).closest('li')
    right = qEl.find('.right')
  
    # Remove question link
    $('<a class="remove">Remove Question</a>').appendTo(@).click ->
      if qEl.filter('[question_id]').length
        question = "<input name='custom_form[questions_attributes][#{qEl.attr('question')}][_destroy]' type='hidden' value='true'>"
        qEl.slideUp 400, -> qEl.replaceWith question
      else
        qEl.slideUp 400, -> qEl.remove()
    
    # TypeStyle select change action
    $(@).on 'change', 'input', ->
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
    right.find('.answers').on 'click', 'li a.remove', ->
      ali = $(@).closest('li')
      ali.slideUp 400, ->
        return unless ali.attr 'question'
        answer = "<input name='custom_form[questions_attributes][#{ali.attr('question')}][predefined_answers_attributes][#{ali.attr('answer')}][_destroy]' type='hidden' value='true'>"
        $(@).replaceWith(answer)
    
    qEl.find('.select input:checked').trigger 'change'
      
  $('form.custom_form .questions > li .container').trigger 'init'