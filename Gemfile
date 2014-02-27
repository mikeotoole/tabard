source 'http://rubygems.org'#                                                               LICENSE - URL

ruby '2.0.0'

# At top so it is before any other gems that use environment variables.
gem 'dotenv-rails', groups: [:development, :test]

# Rails Gem
gem "rails", "~> 3.2.13" #                                                                MIT - https://github.com/rails/rails

gem 'activeadmin'#                                                                        MIT - https://github.com/gregbell/active_admin
gem 'activerecord-postgres-hstore'#                                                       MIT - https://github.com/softa/activerecord-postgres-hstore
gem 'agent_orange'#                                                                       MIT - https://github.com/kevinelliott/agent_orange
gem 'cancan'#                                                                             MIT - https://github.com/ryanb/cancan
gem 'carrierwave'#                                                                        MIT - https://github.com/jnicklas/carrierwave
gem 'client_side_validations'#                                                            MIT - https://github.com/bcardarella/client_side_validations
gem 'country_select'#                                                                     MIT - https://github.com/stefanpenner/country_select
gem 'devise'#                                                                             MIT - https://github.com/plataformatec/devise
gem 'devise-async'#                                                                       MIT - https://github.com/mhfs/devise-async
gem 'dalli', "2.1.0"#                                                                     MIT - https://github.com/mperham/dalli
gem 'delayed_job_active_record'#                                                          MIT - https://github.com/collectiveidea/delayed_job_active_record
gem 'fog'#                                                                                MIT - https://github.com/fog/fog
gem 'foreman'#                                                                            MIT - https://github.com/ddollar/foreman
gem 'friendly_id'#                                                                        MIT - https://github.com/norman/friendly_id
gem 'haml'#                                                                               MIT - https://github.com/haml/haml
gem 'kaminari'#                                                                           MIT - https://github.com/amatsuda/kaminari
gem 'lograge'#                                                                            MIT - https://github.com/roidrage/lograge
gem 'meta_search'#                                                                        MIT - https://github.com/ernie/meta_search
gem 'memcachier'#                                                                         MIT - https://github.com/memcachier/memcachier-gem
gem 'mini_magick'#                                                                        MIT - https://github.com/probablycorey/mini_magick
gem 'nilify_blanks'#                                                                      MIT - https://github.com/rubiety/nilify_blanks
#gem 'oink'#                                                                              MIT - https://github.com/noahd1/oink
gem 'profanalyzer', github: "digitalaugment/profanalyzer"#                                MIT - https://github.com/michaeledgar/profanalyzer
gem 'rack-cors', require: 'rack/cors'#                                                    MIT - https://github.com/cyu/rack-cors
gem 'rails3_acts_as_paranoid'#                                                            MIT - https://github.com/goncalossilva/rails3_acts_as_paranoid
gem 'rdiscount'#                                                                          BSD - https://github.com/rtomayko/rdiscount
gem 'rest-client'#                                                                        MIT - https://github.com/archiloque/rest-client
gem 'rinku'#                                                                              MIT - https://github.com/vmg/rinku
gem 'rotp'#                                                                               MIT - https://github.com/mdp/rotp
gem 'sanitize'#                                                                           MIT - https://github.com/rgrove/sanitize
gem 'simple_form'#                                                                        MIT - https://github.com/plataformatec/simple_form
gem "stripe", "~> 1.7.11"#                                                                MIT - https://github.com/stripe/stripe-ruby
gem "stripe_event", "~> 0.5.0"#                                                           MIT - https://github.com/integrallis/stripe_event
gem 'squeel'#                                                                             MIT - https://github.com/ernie/squeel
gem 'unicorn'#                                                                            GPL - https://github.com/defunkt/unicorn
gem 'unicorn-worker-killer'#                                                              GPL - https://github.com/kzk/unicorn-worker-killer
gem 'validates_lengths_from_database'#                                                    MIT - https://github.com/rubiety/validates_lengths_from_database
gem 'validates_timeliness' #                                                              MIT - https://github.com/adzap/validates_timeliness

# TODO: This should be in the dev test group.
gem 'timecop'#                                                                            MIT - https://github.com/jtrupiano/timecop

# Assets Specific Gems
group :assets do
  gem 'asset_sync'#                                                                       MIT - https://github.com/rumblelabs/asset_sync
  gem 'coffee-rails'#                                                                     MIT - https://github.com/rails/coffee-rails
  gem 'jquery-rails'#                                                                     MIT - https://github.com/indirect/jquery-rails
  gem 'quiet_assets'#                                                                     MIT - https://github.com/evrone/quiet_assets
  gem 'sass-rails'#                                                                       MIT - https://github.com/rails/sass-rails
  gem 'turbo-sprockets-rails3'#                                                           MIT - https://github.com/ndbroadbent/turbo-sprockets-rails3
  gem 'uglifier'#                                                                         MIT - https://github.com/lautis/uglifier
end

# Production Specific Gems
group :production, :staging do
  gem 'hirefire-resource'#                                                                None - https://github.com/meskyanichi/hirefire-resource
  gem 'newrelic_rpm'#                                                                     MIT - https://github.com/newrelic/rpm
  gem 'pg'#                                                                               Ruby - https://bitbucket.org/ged/ruby-pg/wiki/Home
end

# Development Specific Gems
group :development do
  gem 'annotate'#                                                                         Ruby - https://github.com/ctran/annotate_models
  gem 'rails_best_practices'#                                                             MIT - https://github.com/railsbp/rails_best_practices
  gem 'haml-rails'#                                                                       MIT - https://github.com/indirect/haml-rails
  gem 'bullet'#                                                                           MIT - https://github.com/flyerhzm/bullet
  gem 'brakeman'#                                                                         MIT - https://github.com/presidentbeef/brakeman
  gem 'better_errors'#                                                                    MIT - https://github.com/charliesome/better_errors
  gem "binding_of_caller"#                                                                MIT - https://github.com/banister/binding_of_caller
  gem 'thin'#                                                                             Ruby - https://github.com/nragaz/thin-gem
end

# Development and Test Specific Gems
group :development, :test do
  gem 'rspec-rails'#                                                                      MIT - https://github.com/rspec/rspec-rails
  gem 'factory_girl_rails'#                                                               MIT - https://github.com/thoughtbot/factory_girl_rails
  gem 'debugger'#                                                                         MIT - https://github.com/cldwalker/debugger
  gem 'simplecov'#                                                                          MIT - https://github.com/colszowka/simplecov
end

# Test Specific Gems
group :test do
  gem 'capybara', "=1.1.4"#                                                               MIT - https://github.com/jnicklas/capybara
  gem 'database_cleaner'#                                                                 MIT - https://github.com/bmabey/database_cleaner
  gem 'guard-rspec'#                                                                      MIT - https://github.com/guard/guard-rspec
  gem 'guard-livereload'#                                                                 MIT - https://github.com/guard/guard-livereload
  gem 'launchy'#                                                                          ISC - https://github.com/copiousfreetime/launchy
  gem 'rb-fsevent'#                                                                       MIT - https://github.com/thibaudgg/rb-fsevent
  gem 'poltergeist'#                                                                      MIT - https://github.com/jonleighton/poltergeist
  #gem 'growl_notify'#                                                                    MIT - https://github.com/scottdavis/growl_notify
  #gem 'vcr'#                                                                             MIT - https://github.com/vcr/vcr
  #gem 'webmock'#                                                                         MIT - https://github.com/bblimke/webmock
end
