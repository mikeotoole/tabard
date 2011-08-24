=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for announcements.
=end
class AnnouncementsController < ApplicationController
  respond_to :html
  before_filter :authenticate

  def index
    @announcements = current_user.announcements
  end

  def show
    @announcement = Announcement.find_by_id(params[:id])
    case params[:type]
      when "GameAnnouncement"
        redirect_to(game_announcement_url(:subdomain => @announcement.community.subdomain))
      when "CommunityAnnouncement"
        redirect_to(community_announcement_url(:subdomain => @announcement.community.subdomain))
      else
        render :show
    end
  end
end
