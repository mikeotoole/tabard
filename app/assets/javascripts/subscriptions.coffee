jQuery ->
  Stripe.setPublishableKey $('meta[name="stripe-key"]').attr 'content'
  subscription.setupForm()

subscription =
  setupForm: ->
    $('#edit_subscription').submit ->
      if $('#card_number').length
        $(@).find('input[type=submit]').attr 'disabled', true
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
    Stripe.createToken card, @handleStripeResponse

  handleStripeResponse: (status, response) ->
    if status is 200
      $('#community_stripe_card_token').val(response.id)
      $('#edit_subscription')[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr 'disabled', false