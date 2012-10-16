jQuery ->
  Stripe.setPublishableKey $('meta[name="stripe-key"]').attr 'content'
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#form_with_subscription').submit ->
      return true unless $('#cc_fields:visible').length
      
      # Encourage all fields being filled out
      errCount = 0
      for field in $(@).find('input[type=text]')
        $field = $(field)
        $li = $field.closest 'li'
        if $field.val()
          $li.removeClass 'error'
        else
          errCount++
          $li.addClass 'error'
      for select in $(@).find('.select')
        $select = $(select)
        if $select.find('input:checked').length
          $select.removeClass 'error'
        else
          errCount++
          $select.addClass 'error'

      # Errors present?
      if errCount > 0
        $.flash 'alert cardfields', 'Please fill out missing fields.' unless $('#flash .cardfields').length

      # Disable submit and process request
      else
        if requireConfirmation
          $.confirm
            title: 'Confirm Charge'
            body: 'This will submit a payment with the card you provided and configure your recurring monthly subscription.'
            action: -> card.processCard()
        else
          card.processCard()
      false

  processCard: ->
    $('#flash .cardfields .dismiss').trigger 'click'
    $('#form_with_subscription input[type=submit]').prop 'disabled', true
    data =
      name: $('#card_name').val()
      number: $('#card_number').val()
      cvc: $('#card_cvc').val()
      expMonth: $('#card_exp_month input:checked').val()
      expYear: $('#card_exp_year input:checked').val()
      addressZip: $('#card_address_zip').val()
    Stripe.createToken data, @handleStripeResponse

  handleStripeResponse: (status, response) ->
    # Remove old error messages
    $('#flash li').each -> $(@).find('.dismiss').trigger 'click'
    $('#form_with_subscription li').removeClass('with-errors').find('mark.error').remove()

    # Success, so submit the data to Stripe
    if status is 200
      ccFields = $('#cc_fields').find 'input'
      $('#stripe_card_token').val response.id
      ccFields.attr 'disabled', 'disabled'
      $('#form_with_subscription')[0].submit()
      ccFields.removeAttr 'disabled'

    else
      # Show message in DOM
      if response.error.param.match /exp_year|exp_month/
        errorMsg = 'Invalid expiration date.'
      else
        errorMsg = response.error.message
      $.flash 'alert', errorMsg
      li = $("#card_#{response.error.param}").closest('li')
      li.addClass 'with-errors'
      $('<mark class="error">').appendTo(li).text errorMsg

      # Re-enable submit button
      $('#form_with_subscription input[type=submit]').removeAttr 'disabled'


jQuery(document).ready ($) ->

  # Toggling between packages
  $('#form_with_subscription').on 'change', '.plans input', ->
    price = parseInt $(@).attr 'data-price'
    if price
      $('#upgrades, #cc_input').slideDown()
    else
      $('#upgrades, #cc_input').hide()
  $('#form_with_subscription .plans input:checked').trigger 'change'

  # Toggling new/onfile card
  $('#cc_input menu')
    .on 'click', '.onfile', ->
      $('#cc_input').removeClass 'show_fields'
      $('#cc_fields').hide()
    .on 'click', '.newcard', ->
      $('#cc_input').addClass 'show_fields'
      $('#cc_fields').slideDown()

  # Preview the subdomain
  $('#form_with_subscription .community-name input').on 'change keyup', ->
    $this = $(@)
    $li = $this.closest 'li'
    subdomain = $this.val().toLowerCase().replace(/[^a-z]/g, '')
    if subdomain
      url = "http://<span class='subdomain'>#{subdomain}</span>.tabard.co"
      if $li.find('mark.url').length is 0
        console.log 'a'
        $('<mark class="url">').html(url).appendTo $li
      else
        console.log 'b'
        $li.find('mark.url').html url
    else
      $li.find('mark.url').remove()