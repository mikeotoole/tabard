###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling all announcement discussions for the current user.
###
class AnnouncementsController < ApplicationController
  before_filter :block_unauthorized_user!
  respond_to :html, :js

###
# REST Actions
###
  # GET /announcements/:id(.:format)
  def show
    current_community = Community.find_by_id(params[:community_id]) if params[:community_id]
    @announcement = current_user.announcements.find_by_id(params[:id])
    if @announcement != nil
      @announcement.update_viewed(current_user.user_profile)
      respond_to do |format|
        format.js {
          announcement = current_user.unread_announcements.where(community_id: current_community.id).recent.first
          if !!announcement
            render partial: 'layouts/flash_message_announcement', layout: nil, locals: { announcement: announcement }
          else
            render text: ''
          end
        }
        format.html { redirect_to announcement_url(@announcement, subdomain: @announcement.subdomain)}
      end
    else
      raise CanCan::AccessDenied
    end
  end

###
# Added Actions
###
  # PUT /announcements/batch_mark_as_seen/(.:format)
  def batch_mark_as_seen
    if params[:ids]
      params[:ids].each do |id|
        announcement = current_user.announcements.find_by_id(id[0])
        announcement.update_viewed(current_user.user_profile) if announcement
      end
    end
    render text: ''
  end
end
