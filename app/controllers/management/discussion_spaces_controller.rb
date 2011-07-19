class Management::DiscussionSpacesController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /discussion_spaces
  # GET /discussion_spaces.xml
  def index
      @discussion_spaces = @community.discussion_spaces.order("system DESC, name ASC")
      respond_with(@discussion_spaces)
  end

  # GET /discussion_spaces/new
  # GET /discussion_spaces/new.xml
  def new
    @discussion_space = @community.discussion_spaces.new
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      respond_with(@discussion_space)
    end
  end

  # GET /discussion_spaces/1/edit
  def edit
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    end
    respond_with(@discussion_space)
  end

  # POST /discussion_spaces
  # POST /discussion_spaces.xml
  def create
    @discussion_space = @community.discussion_spaces.new(params[:discussion_space])
    @discussion_space.system = false
    @discussion_space.user_profile = current_user.user_profile
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.save
        add_new_flash_message('Discussion space was successfully created.')
        respond_with(@discussion_space)
      else
        grab_all_errors_from_model(@discussion_space)
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
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.update_attributes(params[:discussion_space])
        add_new_flash_message('Discussion space was successfully updated.')
        respond_with(@discussion_space)
      else
        grab_all_errors_from_model(@discussion_space)
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
    @discussion_space = @community.discussion_spaces.find(params[:id])
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
