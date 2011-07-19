class Management::PageSpacesController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:index, :show]
  # GET /page_spaces
  # GET /page_spaces.xml
  def index
    @page_spaces = @community.page_spaces.all

    respond_with(@page_spaces)
  end

  # GET /page_spaces/1
  # GET /page_spaces/1.xml
  def show
    @page_space = @community.page_spaces.find(params[:id])

    respond_with(@page_space)
  end

  # GET /page_spaces/new
  # GET /page_spaces/new.xml
  def new
    @page_space = @community.page_spaces.new
    if !current_user.can_create("PageSpace")
      render_insufficient_privileges
    else
      respond_with(@discussion_space)
    end
  end

  # GET /page_spaces/1/edit
  def edit
    @page_space = @community.page_spaces.find(params[:id])
    if !current_user.can_update("PageSpace") and !current_user.can_update(@page_space)
      render_insufficient_privileges
    end
  end

  # POST /page_spaces
  # POST /page_spaces.xml
  def create
    if !current_user.can_create("PageSpace")
      render_insufficient_privileges
    else
      @page_space = @community.page_spaces.new(params[:page_space])
  
      if @page_space.save
        add_new_flash_message('Page space was successfully created.')
        respond_with(@page_space)
      else 
        grab_all_errors_from_model(@page_space)
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @page_space.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /page_spaces/1
  # PUT /page_spaces/1.xml
  def update
    @page_space = @community.page_spaces.find(params[:id])
    if !current_user.can_update("PageSpace") and !current_user.can_update(@page_space)
      render_insufficient_privileges
    else
      
      if @page_space.update_attributes(params[:page_space])
        add_new_flash_message('Page space was successfully updated.')
        respond_with(@page_space)
      else
        grab_all_errors_from_model(@page_space)
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @page_space.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /page_spaces/1
  # DELETE /page_spaces/1.xml
  def destroy
    @page_space = @community.page_spaces.find(params[:id])
    if !current_user.can_delete("PageSpace") and !current_user.can_delete(@page_space)
      render_insufficient_privileges
    else 
      if @page_space.destroy
        add_new_flash_message('Page space was successfully deleted.')
      end
      respond_with(@page_space)
    end
  end
end
