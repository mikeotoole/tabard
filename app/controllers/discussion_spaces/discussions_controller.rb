class DiscussionSpaces::DiscussionsController < ApplicationController
  respond_to :html, :xml
  before_filter :get_discussion_space_from_id, :authenticate

  # GET /discussions/new
  # GET /discussions/new.xml
  def new
    @discussion = @discussion_space.discussions.new
    @discussion.discussion_space = DiscussionSpace.find_by_id(params[:discussion_space])
    if !current_user.can_create(@discussion)
      render_insufficient_privileges
    else
      respond_with(@discussion)
    end
  end

  # POST /discussions
  # POST /discussions.xml
  def create
    @discussion = @discussion_space.discussions.new(params[:discussion])
    if !current_user.can_create(@discussion)
      render_insufficient_privileges
    else
      @discussion.user_profile = current_user.user_profile
      @discussion.character_proxy = (character_active? ? current_character.character_proxy : nil)
      if @discussion.save
        add_new_flash_message('Discussion was successfully created.')
        respond_with(@discussion)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @discussion.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def get_discussion_space_from_id
    @discussion_space = DiscussionSpace.find_by_id(params[:discussion_space_id])
  end
end
