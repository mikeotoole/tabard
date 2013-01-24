Stripe.api_key = ENV['STRIPE_PRIVATE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']
StripeEvent::WebhookController.skip_before_filter :block_unauthorized_user!
StripeEvent::WebhookController.skip_before_filter :limit_subdomain_access
StripeEvent::WebhookController.before_filter :ensure_secure_subdomain
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
