###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Confirmations Controller
###
class ConfirmationsController < Devise::ConfirmationsController
  prepend_view_path "app/views/devise"
  before_filter :sign_out_admin_user, only: :show

  protected

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    user_profile_url(resource.user_profile, protocol: "http://", subdomain: "www", anchor: "games")
  end

  # Override default path
  def after_resending_confirmation_instructions_path_for(resource_name)
    root_url(subdomain: "www")
  end
end
