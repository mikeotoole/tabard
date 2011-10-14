source 'http://rubygems.org'

# Rails Gem
  gem 'rails'

# Javascript Library
  gem 'jquery-rails'

# Meta Languages
  gem 'haml'
  gem 'squeel'

# User Authentication
  gem 'devise'

# Permissions/AC
  gem 'cancan'

# Form Handling
  gem 'simple_form'
  gem 'client_side_validations'

# Markup
  gem 'rdiscount'
  gem 'sanitize'

# Image Storage and Manipulation
  gem 'fog'
  gem 'mini_magick'
  gem 'carrierwave'

# Admin Portal
  gem 'activeadmin'
  gem "meta_search", '>= 1.1.0.pre'

# Production Specific Gems
  group :production do
    gem 'heroku'
    gem 'thin'
    gem 'pg'
    gem 'newrelic_rpm'
  end

# Asset Specific Gems
  group :assets do
    gem 'sass-rails'
    gem 'coffee-rails'
    gem 'uglifier'
  end

# Development and Test Specific Gems
  group :development, :test do
    gem 'sqlite3'
    gem 'rspec-rails'
  end

# Development Specific Gems
  group :development do
    gem 'annotate'
    gem 'rails_best_practices'
    gem 'haml-rails'
  end

# Test Specific Gems
  group :test do
    gem 'factory_girl_rails'
    gem 'capybara'
    gem 'database_cleaner'
    gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
    gem 'guard-rspec'
    gem 'guard-livereload'
    gem 'growl_notify'
    gem 'simplecov'
    gem 'ruby-debug19'
  end
