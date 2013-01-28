if ENV["COVERAGE"] != 'off'
  require 'simplecov'

  SimpleCov.start 'rails' do
    coverage_dir "doc/reports/test_coverage"
    command_name "RSpec#{rand(100000)}"
    merge_timeout 600
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require "cancan/matchers"
require 'database_cleaner'

require 'capybara/poltergeist'
Capybara.run_server = true #Whether start server when testing
def set_host (host)
  host! host
  Capybara.app_host = "http://" + host
end
Capybara.asset_root = "../../app/assets" # This is needed for save_and_open_page
Capybara.server_port = 1337
Capybara.default_wait_time = 5 #When we testing AJAX, we can set a default wait time
Capybara.ignore_hidden_elements = true #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Database cleaning
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Devise.mailer = "Devise::Mailer"
  end
  config.before(:each) do
    DatabaseCleaner.start
    FactoryGirl.create(:privacy_policy)
    FactoryGirl.create(:terms_of_service)
    Rails.cache.clear
    Timecop.return
  end
  config.after(:each) do
    DatabaseCleaner.clean
    DefaultObjects.clean
  end

  config.include(MailerMacros)
  config.before(:each) { reset_email }

  # Devise extenstions -JW
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller

  # Adds helpers for use in request tests
  config.include Warden::Test::Helpers
  # Adds log in reset
  config.after(:each) { Warden.test_reset! }

  # Lets you write create(:factroy_name) instead of Factory.create(:factroy_name)
  config.include FactoryGirl::Syntax::Methods
end
