Stripe.api_key = ENV['STRIPE_PRIVATE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

StripeEvent.setup do
  subscribe 'charge.failed', 'charge.succeeded', 'charge.refunded', 'charge.disputed' do |event|
    puts "STRIPE_EVENT:CHARGE: #{event.to_yaml}"
    # Charge events
  end

  subscribe 'transfer.created', 'transfer.updated', 'transfer.failed'do |event|
    puts "STRIPE_EVENT:TRANSFER: #{event.to_yaml}"
    # Transfer events
  end

  subscribe do |event|
    puts "STRIPE_EVENT: #{event.to_yaml}"
  end
end
