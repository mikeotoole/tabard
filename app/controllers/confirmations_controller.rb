###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller overrides Devise's Confirmations Controller
###
class ConfirmationsController < Devise::ConfirmationsController
  prepend_view_path "app/views/devise"

  protected

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if resource.is_a?(User)
      user_profile_path(resource.user_profile)
    else
      after_sign_in_path_for(resource)
    end
  end
end
