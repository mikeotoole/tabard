class DiscussionsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /discussions
  # GET /discussions.xml
  def index
    if !current_user.can_show("Discussion")
      render :nothing => true, :status => :forbidden 
    else
      @discussions = Discussion.all
      respond_with(@discussions)
    end
  end

  # GET /discussions/1
  # GET /discussions/1.xml
  def show
    @discussion = Discussion.find(params[:id])
    if !current_user.can_show(@discussion) and !current_user.can_show("Discussion")
      render :nothing => true, :status => :forbidden
    else
      respond_with(@discussion)
    end
  end

  # GET /discussions/new
  # GET /discussions/new.xml
  def new
    @discussion = Discussion.new
    if !current_user.can_create("Discussion")
      render :nothing => true, :status => :forbidden
    else
      respond_with(@discussion)
    end
  end

  # GET /discussions/1/edit
  def edit
    @discussion = Discussion.find(params[:id])
    if !current_user.can_update("Discussion") and !current_user.can_update(@discussion)
      render :nothing => true, :status => :forbidden
    end
  end

  # POST /discussions
  # POST /discussions.xml
  def create
    if !current_user.can_create("Discussion")
      render :nothing => true, :status => :forbidden
    else
      @discussion = Discussion.new(params[:discussion])
      if @discussion.save
        flash[:notice] = 'Discussion was successfully created.'
        respond_with(@discussion)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @discussion.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /discussions/1
  # PUT /discussions/1.xml
  def update
    @discussion = Discussion.find(params[:id])
    if !current_user.can_update("Discussion") and !current_user.can_update(@discussion)
      render :nothing => true, :status => :forbidden
    else
      if @discussion.update_attributes(params[:discussion])
        flash[:notice] = 'Discussion was successfully updated.'
        respond_with(@discussion)
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @discussion.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /discussions/1
  # DELETE /discussions/1.xml
  def destroy
    @discussion = Discussion.find(params[:id])
    if !current_user.can_delete("Discussion") and !current_user.can_delete(@discussion)
      render :nothing => true, :status => :forbidden
    else 
      @discussion.destroy
      respond_with(@discussion)
    end
  end
end
