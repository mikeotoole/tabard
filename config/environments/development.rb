Bv::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost", :port => 3000 }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  #Mail setting for development
  ActionMailer::Base.smtp_settings = {
    :address              => "secure.emailsrvr.com",
    :port                 => 587,
    :user_name            => "development@digitalaugment.com",
    :password             => 'fcsC9bvMqAw1GJ',
    :authentication       => 'plain',
    :enable_starttls_auto => true 
  }
  
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    '<span class="error">'.html_safe << html_tag << '</span>'.html_safe
  end
  
  #tiny_mce stuffs
  config.gem 'tiny_mce'
  
  # This will force the models to be loaded so that subclasses can be seen by there parent.
  %w[game wow swtor base_character wow_character swtor_character profile game_profile user_profile discussion announcement site_announcement game_announcement].each do |c|
    require_dependency File.join("app","models","#{c}.rb")
  end
  
  # This will force the models to be loaded so that subclasses can be seen by there parent.
  %w[question check_box_question combo_box_question radio_button_question text_box_question text_question].each do |c|
    require_dependency File.join("app","models","#{c}.rb")
  end
end
