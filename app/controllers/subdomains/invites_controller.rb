###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling invites within the scope of subdomains (communities).
###
class Subdomains::InvitesController < SubdomainsController
  respond_to :html
###
# Before Filters
###
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  skip_before_filter :limit_subdomain_access
  load_and_authorize_resource :through => :current_user

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
    add_new_flash_message 'Invite was successfully created.','success' if @invite.save
    respond_with(@invite)
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
