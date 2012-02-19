source 'http://rubygems.org'

# Rails Gem
  gem 'rails'

# ActiveRecord extensions
  gem 'rails3_acts_as_paranoid', :git => 'git@github.com:digitalaugment/rails3_acts_as_paranoid.git'

# Javascript Library
  gem 'jquery-rails'

# Meta Languages
  gem 'haml'
  gem 'squeel'

# User Authentication
  gem 'devise'

# Permissions/AC
  gem 'cancan'

# Caching
  gem 'dalli'

# Form Handling
  gem 'simple_form'
  gem 'client_side_validations'

# Filtering
  gem 'profanalyzer' 
  
# Background jobs
  gem 'delayed_job_active_record' 

# Markup
  gem 'rdiscount'
  gem 'sanitize'

# Image Storage and Manipulation
  gem 'fog'
  gem 'mini_magick'
  gem 'carrierwave'
  #gem 'asset_sync'

# Admin Portal
  gem 'meta_search', '>= 1.1.0.pre'
  gem 'activeadmin'

# Asset Specific Gems, Pulled out of Group for Activeadmin
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  
  group :assets do

  end

# Production Specific Gems
  group :production do
    gem 'heroku'
    gem 'thin'
    gem 'pg'
    gem 'newrelic_rpm'
  end

# Development Specific Gems
  group :development do
    gem 'annotate'
    gem 'rails_best_practices'
    gem 'haml-rails'
    gem 'rails-dev-tweaks'
  end

# Development and Test Specific Gems
  group :development, :test do
    gem 'sqlite3'
    gem 'rspec-rails'
    gem 'factory_girl_rails'
    gem 'timecop'
  end

# Test Specific Gems
  group :test do
    gem 'capybara'
    gem 'database_cleaner'
    gem 'rb-fsevent'
    gem 'guard-rspec'
    gem 'guard-livereload'
    gem 'growl_notify'
    gem 'simplecov'
    gem 'ruby-debug19'
  end
