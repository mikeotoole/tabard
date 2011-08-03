=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is for acknowledging announcements.
=end
class AnnouncementAcknowledgementController < ApplicationController
  include ActionView::Helpers::TagHelper
  
  def new
    @announcement_acknowledgement = AcknowledgmentOfAnnouncement.find_by_id(params[:id])
    if @announcement_acknowledgement != nil
      @announcement_acknowledgement.acknowledged = true
      @announcement_acknowledgement.save
    else
      add_new_flash_message('Try refreshing the page to load all current announcements.','alert','Announcement not found')
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
end