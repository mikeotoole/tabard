class AnnouncementAcknowledgementController < ApplicationController
  include ActionView::Helpers::TagHelper
  
  def new
    @announcement_acknowledgement = AcknowledgmentOfAnnouncement.find_by_id(params[:id])
    if @announcement_acknowledgement != nil
      @announcement_acknowledgement.acknowledged = true
      @announcement_acknowledgement.save
    else
      flash[:messages] = Array.new unless flash[:messages]
      flash[:messages] << { :class => 'alert', :title => 'Announcement not found ', :body => 'Try refreshing the page to load all current announcements.' }
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
end