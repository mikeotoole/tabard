class DiscussionsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /discussions
  # GET /discussions.xml
  def index
    @discussions = Discussion.all
    respond_with(@discussions)
  end

  # GET /discussions/1
  # GET /discussions/1.xml
  def show
    @discussion = Discussion.find(params[:id])
    if !current_user.can_show(@discussion)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@discussion)
    end
  end

  # GET /discussions/new
  # GET /discussions/new.xml
  def new
    @discussion = Discussion.new
    @discussion.discussion_space = DiscussionSpace.find_by_id(params[:discussion_space])
    if !current_user.can_create(@discussion)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@discussion)
    end
  end

  # GET /discussions/1/edit
  def edit
    @discussion = Discussion.find(params[:id])
    if !current_user.can_update(@discussion)
      render :nothing => true, :status => :forbidden
    end
  end

  # POST /discussions
  # POST /discussions.xml
  def create
    @discussion = Discussion.new(params[:discussion])
    if !current_user.can_create(@discussion)
      render :nothing => true, :status => :forbidden
    else
      @discussion.user_profile = current_user.user_profile
      @discussion.character = (character_active? ? current_character : nil)
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
    if !current_user.can_update(@discussion)
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
    if !current_user.can_delete(@discussion)
      render :nothing => true, :status => :forbidden
    else 
      @discussion.destroy
      respond_with(@discussion)
    end
  end
  
  def lock
    @discussion = Discussion.find_by_id(params[:id])
    if @discussion.can_user_lock(current_user)
      @discussion.has_been_locked = true
      if @discussion.save 
        flash[:notice] = "Discussion was successfully locked."
      else
        flash[:alert] = "Discussion was not locked, internal rails error."
      end
      redirect_to :back
      return
    end
    render :nothing => true, :status => :forbidden
  end
  
  def unlock
    @discussion = Discussion.find_by_id(params[:id])
    if @discussion.can_user_lock(current_user)
      @discussion.has_been_locked = false
      if @discussion.save 
        flash[:notice] = "Discussion was successfully unlocked."
      else
        flash[:alert] = "Discussion was not unlocked, internal rails error."
      end
      redirect_to :back
      return
    end
    render :nothing => true, :status => :forbidden
  end
end
