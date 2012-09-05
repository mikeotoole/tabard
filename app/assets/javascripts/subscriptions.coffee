jQuery ->
  Stripe.setPublishableKey $('meta[name="stripe-key"]').attr 'content'
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#form_with_subscription').submit ->
      if $('#card_number').length
        $(@).find('input[type=submit]').prop 'disabled', true
        subscription.processCard()
        false
      else
        true

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
      name: $('#card_name').val()
      addressZip: $('#card_address_zip').val()
    Stripe.createToken card, @handleStripeResponse

  handleStripeResponse: (status, response) ->
    if status is 200
      $('#stripe_card_token').val(response.id)
      $('#form_with_subscription')[0].submit()
    else
      $.flash 'error', response.error.message
      $('input[type=submit]').prop 'disabled', false


jQuery(document).ready ($) ->

  $('body').on 'change', '.select.members_package input', ->
    selectEl = $(@).closest '.select'
    data = selectEl.data()
    val = selectEl.find('input:checked').val()

    # Update population percentage bar
    newMax = 100 + val * 20
    curVal = $('#population .value').data 'value'
    $('#population').attr 'data-max', "#{newMax} Members Max"
    $('#population .value').css minWidth: "#{Math.round(curVal / newMax * 1000) / 10}%"

    # Destroy package on/off
    if data.destroy?
      destroyEl = $("input[data-destroy='#{data.destroy}']")
      destroyEl.val if parseInt(val) is 0 then 'true' else 'false'