jQuery ->
  Stripe.setPublishableKey $('meta[name="stripe-key"]').attr 'content'
  card.setup()

card =
  setup: ->
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
            actions:
              confirm: -> card.process()
        else
          card.process()
      false

  process: ->
    $('#flash .cardfields .dismiss').trigger 'click'
    $('#form_with_subscription input[type=submit]').prop 'disabled', true
    data =
      name: $('#card_name').val()
      number: $('#card_number').val()
      cvc: $('#card_cvc').val()
      expMonth: $('#card_exp_month input:checked').val()
      expYear: $('#card_exp_year input:checked').val()
      addressLine1: $('#card_address').val()
      addressCity: $('#card_city').val()
      addressState: $('#card_state').val()
      addressZip: $('#card_zip').val()
    $('body').addClass 'busy'
    Stripe.createToken data, @handleStripeResponse

  handleStripeResponse: (status, response) ->
    $('body').removeClass 'busy'

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

  # Preflight check on community name/subdomain
  checkName = (name) ->
    $this = $('#form_with_subscription .community-name')
    $.ajax
      url: '/communities/check_name.js'
      data:
        name: name
      type: 'get'
      dataType: 'json'
      before: -> $this.addClass 'busy'
      complete: -> $this.removeClass 'busy'
      success: (data, status, xhr) ->
        $this.find('mark.error').remove()
        if !!data.success
          $this.addClass 'valid'
          $this.removeClass 'with-errors'
        else
          $this.removeClass 'valid'
          $this.addClass 'with-errors'
          $('<mark class="error">').text(data.errors[0]).appendTo $this

  # Preview the subdomain
  $('#form_with_subscription .community-name input').on 'change keyup', ->
    $this = $(@)
    $li = $this.closest 'li'
    name = $this.val()
    subdomain = name.toLowerCase().replace(/[^a-z]/g, '')
    if subdomain
      url = "http://<span class='subdomain'>#{subdomain}</span>.tabard.co"
      if $li.find('mark.url').length is 0
        $('<mark class="url">').html(url).appendTo $li
      else
        $li.find('mark.url').html url
      checkName name
    else
      $li.find('mark.url').remove()