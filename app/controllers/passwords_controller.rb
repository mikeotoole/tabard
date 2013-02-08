###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Confirmations Controller
###
class PasswordsController < Devise::PasswordsController
  prepend_view_path "app/views/devise"
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :ensure_accepted_most_recent_legal_documents, :limit_subdomain_access
  skip_before_filter :ensure_not_ssl_mode
  before_filter :ensure_secure_subdomain, only: [:edit, :update]
  before_filter :sign_out_admin_user, only: :update

   # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      root_url(subdomain: "www")
    end
end
