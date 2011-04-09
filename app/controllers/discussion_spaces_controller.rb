class DiscussionSpacesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /discussion_spaces
  # GET /discussion_spaces.xml
  def index
      @discussion_spaces = DiscussionSpace.order("system DESC, name ASC")
      respond_with(@discussion_spaces)
  end

  # GET /discussion_spaces/1
  # GET /discussion_spaces/1.xml
  def show
    @discussion_space = DiscussionSpace.find(params[:id])
    
    if !current_user.can_show(@discussion_space)
      render :nothing => true, :status => :forbidden
    else   
      # Site Announcement Space
      if(@discussion_space.system and @discussion_space.announcement_space and @discussion_space.game == nil)
        render :file => 'discussion_spaces/site_announcement_space'
        return
      # Game Announcement Space
      elsif(@discussion_space.system and @discussion_space.announcement_space and @discussion_space.game != nil)
        render :file => 'discussion_spaces/game_announcement_space'
        return
      # Registraion Appication Space
      elsif(@discussion_space.system and @discussion_space.registration_application_space != nil)
        @registration_applications = RegistrationApplication.all_new
        @form = SiteForm.application_form
        render :file => 'discussion_spaces/registration_application_space'
        return  
      end  
      respond_with(@discussion_space)
    end
  end
end
