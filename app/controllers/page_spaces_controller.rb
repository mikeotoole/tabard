class PageSpacesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:index, :show]
  # GET /page_spaces
  # GET /page_spaces.xml
  def index
    @page_spaces = PageSpace.all

    respond_with(@page_spaces)
  end

  # GET /page_spaces/1
  # GET /page_spaces/1.xml
  def show
    @page_space = PageSpace.find(params[:id])

    respond_with(@page_space)
  end

  # GET /page_spaces/new
  # GET /page_spaces/new.xml
  def new
    @page_space = PageSpace.new
    if !current_user.can_create(@page_space)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@page_space)
    end
  end

  # GET /page_spaces/1/edit
  def edit
    @page_space = PageSpace.find(params[:id])
    if !current_user.can_update(@page_space)
      render :nothing => true, :status => :forbidden
    end
  end

  # POST /page_spaces
  # POST /page_spaces.xml
  def create
    @page_space = PageSpace.new(params[:page_space])
    if !current_user.can_create(@page_space)
      render :nothing => true, :status => :forbidden
    else
  
      if @page_space.save
        flash[:notice] = 'Page space was successfully created.'
        respond_with(@page_space)
      else 
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
    @page_space = PageSpace.find(params[:id])
    if !current_user.can_update(@page_space)
      render :nothing => true, :status => :forbidden
    else
      
      if @page_space.update_attributes(params[:page_space])
        flash[:notice] = 'Page space was successfully updated.'
        respond_with(@page_space)
      else
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
    @page_space = PageSpace.find(params[:id])
    if !current_user.can_delete(@page_space)
      render :nothing => true, :status => :forbidden
    else 
      @page_space.destroy
      respond_with(@page_space)
    end
  end
end
