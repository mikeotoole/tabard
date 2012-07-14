###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling invites within the scope of subdomains (communities).
###
class Subdomains::InvitesController < SubdomainsController
  respond_to :html, :js
###
# Before Filters
###
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  skip_before_filter :limit_subdomain_access
  load_and_authorize_resource through: :current_user, except: [:batch_update]

###
# REST Actions
###
  # GET /invites/edit(.:format)
  def edit
    @invite.update_viewed(current_user.user_profile)
    respond_with(@invite)
  end

  # POST /invites(.:format)
  def update
    add_new_flash_message 'Invite was successfully created.','success' if @invite.update_attributes(params[:invite])
    respond_with(@invite, location: event_url(@invite.event))
  end

###
# Added Actions
###
  # PUT /invites/batch_update/(.:format)
  def batch_update
    @invites = []
    valid_status = params[:status] if params[:status] and Invite::VALID_STATUSES.include? params[:status]
    if params[:ids]
      params[:ids].each do |id|
        invite = current_user.invites.find_by_id(id)
        if invite
          @invites << invite
          invite.update_viewed(current_user.user_profile)
          invite.update_attribute(:status, valid_status) if valid_status
        end
      end
    end
    respond_with(@invites, location: events_url)
  end

###
# Public Methods
###
  # This method returns the current game that is in scope.
  def current_game
    @invite.supported_game if @invite and @invite.persisted?
  end
  helper_method :current_game
end
