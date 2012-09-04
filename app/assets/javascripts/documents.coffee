jQuery(document).ready ($) ->

  # Enforce document scrolling
  $('.document .scroll')
    .wrapInner('<div class="pane" />')
    .css('height', 190)
    .bind 'scroll', ->
      boxH = $(@).height()
      paneH = $(@).find('.pane').height()
      if paneH <= boxH || $(@).scrollTop() >= paneH - boxH
        $(@)
          .closest('.document')
          .find('.accept')
          .css({ opacity: 1 })
          .find('input')
          .removeAttr('disabled')
          .find('+ label')
          .unbind('click')
  $('.document:has(.scroll) .accept input[type="checkbox"]:not(:checked)')
    .attr('disabled', true)
    .closest('.accept')
    .css({ opacity: .5 })
    .closest('.document')
    .after('<dfn class="hint">Scroll before accepting</dfn>')
  $('.document:has(.scroll) .accept label')
    .bind 'click', ->
      if $(@).closest('.accept').find('input:disabled')
        $.alert body: "Make sure that you read and <b>scroll to the end</b> of each document before accepting the terms."
        false
      else
        true
  $('.document .scroll').trigger 'scroll'