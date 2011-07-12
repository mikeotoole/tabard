class Management::PagesController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:index, :show]
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all

    respond_with(@pages)
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])

    respond_with(@page)
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    if !current_user.can_create("Page")
      render_insufficient_privileges
    else
      respond_with(@page)
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
    if !current_user.can_update("Page") and !current_user.can_update(@page)
      render_insufficient_privileges
    end
  end

  # POST /pages
  # POST /pages.xml
  def create
    if !current_user.can_create("Page")
      render_insufficient_privileges
    else
      @page = Page.new(params[:page])
      
      if @page.save
        add_new_flash_message('Page was successfully created.')
        respond_with(@page)
      else 
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])
    if !current_user.can_update("Page") and !current_user.can_update(@page)
      render_insufficient_privileges
    else
      if @page.update_attributes(params[:page])
        add_new_flash_message('Page was successfully updated.')
        respond_with(@page)
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    if !current_user.can_delete("Page") and !current_user.can_delete(@page)
      render_insufficient_privileges
    else
      if @page.destroy
        add_new_flash_message('Page was successfully deleted.')
      end
      respond_with(@page)
    end
  end
end
