###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling all invites for the current user.
###
class InvitesController < ApplicationController
  before_filter :block_unauthorized_user!
  respond_to :html

###
# REST Actions
###
  # GET /announcements/:id(.:format)
  def show
    current_community = Community.find_by_id(params[:community_id]) if params[:community_id]
    @invite = current_user.invites.find_by_id(params[:id])
    if @invite != nil
      @invite.update_viewed(current_user.user_profile)
      redirect_to edit_invite_url(@invite, :subdomain => @invite.community_subdomain)
    else
      raise CanCan::AccessDenied
    end
  end

###
# Added Actions
###
  # PUT /invites/batch_update/(.:format)
  def batch_update
    valid_status = params[:status] if params[:status] and Invite::VALID_STATUSES.include? params[:status]
    if params[:ids]
      params[:ids].each do |id|
        invite = current_user.invites.find_by_id(id[0])
        if invite
          invite.update_viewed(current_user.user_profile) 
          invite.update_attribute(:status, valid_status) if valid_status
        end
      end
    end
    render :text => ''
  end
end
