class Subdomains::Management::DiscussionSpacesController < SubdomainsController
  respond_to :html, :xml
  before_filter :authenticate

  def index
      @discussion_spaces = @community.discussion_spaces.order("system DESC, name ASC")
      respond_with(@discussion_spaces)
  end

  def new
    @discussion_space = @community.discussion_spaces.new
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      respond_with(@discussion_space)
    end
  end

  def edit
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    end
    respond_with(@discussion_space)
  end

  def create
    @discussion_space = @community.discussion_spaces.new(params[:discussion_space])
    @discussion_space.system = false # TODO The database should do this by default - JW
    @discussion_space.user_profile = current_user.user_profile
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.save
        add_new_flash_message('Discussion space was successfully created.')
      end
      grab_all_errors_from_model(@discussion_space)
      respond_with(@discussion_space)
    end
  end

  def update
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.update_attributes(params[:discussion_space])
        add_new_flash_message('Discussion space was successfully updated.')
        
      end
      grab_all_errors_from_model(@discussion_space)
      respond_with(@discussion_space)
    end
  end

  def destroy
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_delete(@discussion_space)
      render_insufficient_privileges
    else 
      if @discussion_space.destroy
        add_new_flash_message('Discussion space was successfully deleted.')
      end
      grab_all_errors_from_model(@discussion_space)
      respond_with(@discussion_space)
    end
  end
end
