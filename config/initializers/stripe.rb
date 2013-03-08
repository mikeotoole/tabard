Stripe.api_key = ENV['STRIPE_PRIVATE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

StripeEvent.setup do
  subscribe 'charge.failed', 'charge.refunded', 'charge.dispute.created', 'charge.dispute.updated', 'charge.dispute.closed' do |event|
    puts "ALERT_ERROR STRIPE_EVENT:CHARGE: #{event.type}:#{event.id} ChargeID:#{event.data.object.id}"
  end

  subscribe 'charge.succeeded' do |event|
    #puts "STRIPE_EVENT:CHARGE: #{event.type}:#{event.id}"
  end

  subscribe 'customer.deleted' do |event|
    puts "ALERT_ERROR STRIPE_EVENT:CUSTOMER:DELETED: #{event.type}:#{event.id}"
  end

  subscribe 'transfer.created', 'transfer.updated', 'transfer.failed'do |event|
    puts "ALERT_ERROR STRIPE_EVENT:TRANSFER: #{event.type}:#{event.id}"
  end

  subscribe do |event|
    #puts "STRIPE_EVENT: #{event.type}:#{event.id}"
  end
end
