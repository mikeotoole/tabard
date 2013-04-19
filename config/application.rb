require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(assets: %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module DaBvRails
  class Application < Rails::Application

    # Rack/CORS
    config.middleware.insert_before Warden::Manager, Rack::Cors do
      allow do
        origins %r{^https?:\/\/[a-z0-9\-]+.#{ENV['BV_HOST_DOMAIN']}:?\d*$}i
        resource '*',
          headers: ['Origin', 'Accept', 'Content-Type'],
          methods: [:get, :put, :create, :delete]
      end
    end

    # Mailer
    config.to_prepare do
      Devise::Mailer.layout 'mailer'
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    config.active_record.observers =  :admin_user_observer, :character_observer, :community_observer,
                                      :community_application_observer, :roster_assignment_observer, :user_profile_observer, :discussion_observer,
                                      :message_association_observer, :acknowledgement_observer, :comment_observer,
                                      :invite_observer, :support_ticket_observer, :support_comment_observer, :community_invite_observer

    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    config.assets.precompile += %w(active_admin.css active_admin.js application/*.* themes/*.* top_level/*.* *.js)

    # This protects attributes automatically
    config.active_record.whitelist_attributes = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    #config.active_record.schema_format = :sql

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Pacific Time (US & Canada)"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation, :validation_code]

    # Filter Stripe Webhook Params
    config.filter_parameters += [:active_card]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'

    # This will make our app handle exceptions. So in the routes we can route exceptions to controllers to handle.
    config.exceptions_app = self.routes

    # Use a different logger for distributed setups. This is here for Heroku and Unicorn.
    config.logger = Logger.new(STDOUT)

    # Configure what files get generated with rails generate command.
    config.generators do |g|
      g.helper false
      g.javascripts false
      g.stylesheets false
      g.routing_specs false
      g.view_specs false
      g.request_specs false
    end
  end
end