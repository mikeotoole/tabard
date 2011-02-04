class AnnouncementAcknowledgementController < ApplicationController
  
  def new
    @announcement_acknowledgement = AcknowledgmentOfAnnouncement.find_by_id(params[:id])
    if @announcement_acknowledgement != nil
      @announcement_acknowledgement.acknowledged = true
      @announcement_acknowledgement.save
    else
      flash[:alert] = 'Announcement not found.' << params[:id]
    end
    redirect_to :back
  end
  
end