class DiscussionSpacesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /discussion_spaces
  # GET /discussion_spaces.xml
  def index
      @discussion_spaces = DiscussionSpace.all
      respond_with(@discussion_spaces)
  end

  # GET /discussion_spaces/1
  # GET /discussion_spaces/1.xml
  def show
    @discussion_space = DiscussionSpace.find(params[:id])
    if !current_user.can_show(@discussion_space)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@discussion_space)
    end
  end

  # GET /discussion_spaces/new
  # GET /discussion_spaces/new.xml
  def new
    @discussion_space = DiscussionSpace.new
    if !current_user.can_create(@discussion_space)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@discussion_space)
    end
  end

  # GET /discussion_spaces/1/edit
  def edit
    @discussion_space = DiscussionSpace.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render :nothing => true, :status => :forbidden
    end
    respond_with(@discussion_space)
  end

  # POST /discussion_spaces
  # POST /discussion_spaces.xml
  def create
    @discussion_space = DiscussionSpace.new(params[:discussion_space])
    if !current_user.can_create(@discussion_space)
      render :nothing => true, :status => :forbidden
    else
      if @discussion_space.save
        flash[:notice] = 'Discussion space was successfully created.'
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
      render :nothing => true, :status => :forbidden
    else
      if @discussion_space.update_attributes(params[:discussion_space])
        flash[:notice] = 'Discussion space was successfully updated.'
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
      render :nothing => true, :status => :forbidden
    else 
      @discussion_space.destroy
      respond_with(@discussion_space)
    end
  end
end
