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
  skip_before_filter :limit_subdomain_access
  skip_before_filter :ensure_not_ssl_mode

end
