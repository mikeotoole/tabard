class DiscussionSpacesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /discussion_spaces
  # GET /discussion_spaces.xml
  def index
      @discussion_spaces = DiscussionSpace.where{(system == false) | (registration_application_space == true) | (personal_space == true)}.order("name ASC")
      @discussion_spaces.delete_if {|discussion_space| (!current_user.can_show(discussion_space))}
      if !current_user.can_show("DiscussionSpace")
        render_insufficient_privileges
      else
        respond_with(@discussion_spaces)
      end
  end

  # GET /discussion_spaces/1
  # GET /discussion_spaces/1.xml
  def show
    @discussion_space = DiscussionSpace.find(params[:id])
    #if @discussion_space.system
    #  render_404
    #  return
    #end
    if !current_user.can_show(@discussion_space)
      render_insufficient_privileges
    else   
      # Site Announcement Space
      #if(@discussion_space.system and @discussion_space.announcement_space and @discussion_space.game == nil)
      #  render :partial => 'discussion_spaces/site_announcement_space'
      # Game Announcement Space
      #elsif(@discussion_space.system and @discussion_space.announcement_space and @discussion_space.game != nil)
      #  render :partial => 'discussion_spaces/game_announcement_space'
      # Registraion Appication Space
      #elsif(@discussion_space.system and @discussion_space.registration_application_space != nil)
      #  @registration_applications = RegistrationApplication.all_new
      #  @form = SiteForm.application_form
      #  render :partial => 'discussion_spaces/registration_application_space'  
      #end 
      respond_with(@discussion_space)
    end
  end
  
  # GET /discussion_spaces/new
  # GET /discussion_spaces/new.xml
  def new
    @discussion_space = DiscussionSpace.new
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      respond_with(@discussion_space)
    end
  end

  # GET /discussion_spaces/1/edit
  def edit
    @discussion_space = DiscussionSpace.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    end
    respond_with(@discussion_space)
  end

  # POST /discussion_spaces
  # POST /discussion_spaces.xml
  def create
    @discussion_space = DiscussionSpace.new(params[:discussion_space])
    @discussion_space.system = false
    @discussion_space.user_profile = current_user.user_profile
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.save
        add_new_flash_message('Discussion space was successfully created.')
        respond_with(@discussion_space)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @discussion_space.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /discussion_spaces/1
  # PUT /discussion_spaces/1.xml
  def update
    @discussion_space = DiscussionSpace.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.update_attributes(params[:discussion_space])
        add_new_flash_message('Discussion space was successfully updated.')
        respond_with(@discussion_space)
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @discussion_space.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /discussion_spaces/1
  # DELETE /discussion_spaces/1.xml
  def destroy
    @discussion_space = DiscussionSpace.find(params[:id])
    if !current_user.can_delete(@discussion_space)
      render_insufficient_privileges
    else 
      if @discussion_space.destroy
        add_new_flash_message('Discussion space was successfully deleted.')
      end
      respond_with(@discussion_space)
    end
  end
end
