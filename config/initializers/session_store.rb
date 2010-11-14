# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_BrutalVenom_session',
  :secret      => '31b3828603f0bd910014f6c70b999abe3c76809e6661c0483d9c9380513b17cb95f420379edb440e775652fcc3de105a1ee0bf858b76966dc6d404f03c3deb4f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
