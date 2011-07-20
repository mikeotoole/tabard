class PageSpacesController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:index, :show]
  def index
    @page_spaces = @community.page_spaces.all
    respond_with(@page_spaces)
  end

  def show
    @page_space = @community.page_spaces.find(params[:id])
    respond_with(@page_space)
  end

  def new
    @page_space = @community.page_spaces.new
    if !current_user.can_create(@page_space)
      render_insufficient_privileges
    else
      respond_with(@page_space)
    end
  end

  def edit
    @page_space = @community.page_spaces.find(params[:id])
    if !current_user.can_update(@page_space)
      render_insufficient_privileges
    end
    repsond_with(@page_space)
  end

  def create
    @page_space = @community.page_spaces.new(params[:page_space])
    if !current_user.can_create(@page_space)
      render_insufficient_privileges
    else
      if @page_space.save
        add_new_flash_message('Page space was successfully created.')
      end
      grab_all_errors_from_model(@page_space)
      respond_with(@page_space)
    end
  end

  def update
    @page_space = @community.page_spaces.find(params[:id])
    if !current_user.can_update(@page_space)
      render_insufficient_privileges
    else      
      if @page_space.update_attributes(params[:page_space])
        add_new_flash_message('Page space was successfully updated.')
      end
      grab_all_errors_from_model(@page_space)
      respond_with(@page_space)
    end
  end

  def destroy
    @page_space = @community.page_spaces.find(params[:id])
    if !current_user.can_delete(@page_space)
      render_insufficient_privileges
    else 
      if @page_space.destroy
        add_new_flash_message('Page space was successfully deleted.')
      end
      grab_all_errors_from_model(@page_space)
      respond_with(@page_space)
    end
  end
end
