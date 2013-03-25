Stripe.api_key = ENV['STRIPE_PRIVATE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

StripeEvent.setup do
  subscribe 'charge.failed', 'charge.refunded', 'charge.dispute.created', 'charge.dispute.updated', 'charge.dispute.closed' do |event|
    puts "ALERT_ERROR controller=STRIPE_EVENT:CHARGE event_type=#{event.type} event_id=#{event.id} charge_id=#{event.data.object.id}"
  end

  subscribe 'charge.succeeded' do |event|
    #puts "controller=STRIPE_EVENT:CHARGE event_type=#{event.type} event_id=#{event.id} charge_id=#{event.data.object.id}"
  end

  subscribe 'customer.deleted' do |event|
    puts "ALERT_ERROR controller=STRIPE_EVENT:CUSTOMER:DELETED event_type=#{event.type} event_id=#{event.id}"
  end

  subscribe 'transfer.created', 'transfer.updated', 'transfer.failed'do |event|
    puts "ALERT_ERROR controller=STRIPE_EVENT:TRANSFER event_type=#{event.type} event_id=#{event.id}"
  end

  subscribe do |event|
    #puts "STRIPE_EVENT: event_type=#{event.type} event_id=#{event.id}"
  end
end
