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

  $('body').on 'change', '.select[data-destroy] input', ->
    selectEl = $(@).closest '.select'
    data = selectEl.data()
    val = selectEl.find('input:checked').val()
    destroyEl = $("input[data-destroy='#{data.destroy}']")
    destroyEl.val if parseInt(val) is 0 then 'true' else 'false'