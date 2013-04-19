DaBvRails::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Added to help with Heroku error -MO
  config.assets.initialize_on_precompile = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # The levels available on the logger are (in ascending order): debug, info, warn, error, and fatal.
  config.log_level = :debug

  # Add info to the logs for tracking requests.
  # config.log_tags = [ :remote_ip ]

  # Turn on lograge. See https://github.com/roidrage/lograge
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    # Add values to log output. See ApplicationController append_info_to_payload method.
    {
      remote_ip: event.payload[:remote_ip],
      request_id: event.payload[:request_id],
      current_user_id: event.payload[:current_user_id],
      current_admin_user_id: event.payload[:current_admin_user_id],
      params: event.payload[:params].with_indifferent_access.except(:action, :controller)
    }
  end

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = "https://#{ENV['BV_ASSETS_DIRECTORY']}.s3.amazonaws.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Default mailer url
  config.action_mailer.default_url_options = { host: 'brutalvenom.com' }

  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: '587',
    authentication: :plain,
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    domain: 'brutalvenom.com'
  }
  ActionMailer::Base.delivery_method = :smtp
end