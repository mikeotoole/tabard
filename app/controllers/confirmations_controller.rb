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
  after_filter :change_notices_to_successes, only: [:create]

  protected

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    after_sign_in_path_for(resource)
  end

  # Override default path
  def after_resending_confirmation_instructions_path_for(resource_name)
    root_url
  end
end
