source 'http://rubygems.org'

# Rails Gem
  gem 'rails'

  # Gems used only for assets and not required
  # in production environments by default.
  group :assets do
    gem 'sass-rails'
    gem 'coffee-rails'
    gem 'uglifier'
  end

  gem 'jquery-rails'

# Global Gems
  # Meta Languages
    gem 'haml'
    #gem 'sass'
    gem 'squeel'
    #gem 'coffee-script'

  # User Authentication
    gem 'devise'
  # Permissions/AC
    gem 'cancan'

  # Form Handling
    gem 'simple_form'
    gem 'client_side_validations'

  # WYSIWYG
    gem 'tiny_mce'

  # Image Storage and Manipulation
    gem 'fog'
    gem 'mini_magick'
    gem 'carrierwave'

# Multi-Group Gems
    gem 'rspec-rails', :group => [:development, :test]

# Development Specific Gems
  group :development do
    gem 'annotate' # Documentation Helper
    gem 'rails_best_practices' # Best Practices Gem
    gem 'sqlite3'
    gem 'haml-rails' # Haml Generator Gem
  end

# Production Specific Gems
  group :production do
    gem 'heroku'
    #gem 'thin'
    #gem 'pg'
    gem 'newrelic_rpm'
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
    gem 'simplecov', '0.4.2'
  end
