###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class Subdomains::CommunitiesController < SubdomainsController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :authenticate_user!
  load_and_authorize_resource

###
# REST Actions
###
  # GET /community_settings(.:format)
  def edit
  end

  # PUT /community_settings(.:format)
  def update
    if @community.update_attributes(params[:community])
      add_new_flash_message 'Your changes have been saved.', 'success'
    else
      add_new_flash_message 'Error. Unable to save changes.', 'alert'
    end
    respond_with(@community, :location => edit_community_settings_url(@community))
  end
  
  def remove_confirmation
  end

  # DELETE /communities/:id(.:format)
  def destroy # TODO Joe, This needs to use SSL.
    if params[:user] and current_user.valid_password?(params[:user][:current_password])
      Community.delay.destory_community(@community.id)
      @community.update_attribute(:pending_removal, true)
      add_new_flash_message 'Community is being removed.', 'notice'
      redirect_to user_root_url
    else
      add_new_flash_message 'Password was not valid.', 'alert'
      redirect_to community_remove_confirmation_url
    end
  end
end
