###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling all invites for the current user.
###
class InvitesController < ApplicationController
  before_filter :block_unauthorized_user!
  load_and_authorize_resource through: :current_user, except: [:batch_update]
  respond_to :html, :js

###
# REST Actions
###
  # GET /announcements/:id(.:format)
  def show
    @invite.update_viewed(current_user.user_profile)
    respond_with(@invite, location: edit_invite_url(@invite, subdomain: @invite.community_subdomain))
  end
  # Update
  def update
    @invite.update_attributes(params[:invite])
    respond_with(@invite, location: edit_invite_url(@invite, subdomain: @invite.community_subdomain))
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
          invite.update_column(:status, valid_status) if valid_status
        end
      end
    end
    respond_to do |format|
      format.html { respond_with(@invites, location: user_profile_url(current_user.user_profile, anchor: 'invites')) }
      format.js { render json: { success: true, invites: @invites, fresh_invites_count: current_user.invites.not_responded_to.fresh.size } }
    end
  end
end
