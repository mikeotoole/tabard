class PagesController < ApplicationController
  uses_tiny_mce :options => {
                              :theme => 'advanced',
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :plugins => %w{ table fullscreen }
                            },
                :only => [:new, :create, :edit, :update]
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
      render :nothing => true, :status => :forbidden
    else
      respond_with(@page)
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
    if !current_user.can_update("Page") and !current_user.can_update(@page)
      render :nothing => true, :status => :forbidden
    end
  end

  # POST /pages
  # POST /pages.xml
  def create
    if !current_user.can_create("Page")
      render :nothing => true, :status => :forbidden
    else
      @page = Page.new(params[:page])
      
      if @page.save
        flash[:notice] = 'Page was successfully created.'
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
      render :nothing => true, :status => :forbidden
    else
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
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
      render :nothing => true, :status => :forbidden
    else
      @page.destroy
      respond_with(@page)
    end
  end
end
