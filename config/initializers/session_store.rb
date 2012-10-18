# Be sure to restart your server when you modify this file.
if Rails.env.production?
  require 'action_dispatch/middleware/session/dalli_store'
  DaBvRails::Application.config.session_store :dalli_store, memcache_server: ['host1', 'host2'], namespace: 'sessions', key: '_foundation_session', domain: '.tabard.co'
else
  DaBvRails::Application.config.session_store :cookie_store, key: '_da-bv-rails_session', domain: "lvh.me"
end
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# DaBvRails::Application.config.session_store :active_record_store
