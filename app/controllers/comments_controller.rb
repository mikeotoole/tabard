class CommentsController < ApplicationController
  respond_to :html, :xml, :js
  before_filter :authenticate
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_with(@comments)
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])
    if !current_user.can_show(@comment)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@comment)
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
    if !current_user.can_create(@comment)
      render :nothing => true, :status => :forbidden
    else
      @comment.user_profile = current_user.user_profile
      @comment.character_proxy_id = current_character.character_proxy.id if character_active?
      @comment.commentable_id = params[:commentable_id]
      @comment.commentable_type = params[:commentable_type]
      @comment.form_target = params[:form_target]
      @comment.comment_target = params[:comment_target]
      respond_with(@comment)
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    if !current_user.can_update(@comment)
      render :nothing => true, :status => :forbidden
    end
    respond_with(@comment)
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    if !current_user.can_create(@comment)
      render :nothing => true, :status => :forbidden
    else
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        #redirect_to(:back)
        respond_with(@comment)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
          format.js { render 'fail_create.js.erb' }
        end
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])
    if !current_user.can_update(@comment)
      render :nothing => true, :status => :forbidden
    else
      @comment.has_been_edited = true
      respond_to do |format|
        if @comment.update_attributes(params[:comment])
          flash[:notice] = 'Comment was successfully updated.'
          redirect_to url_for(@comment.original_comment_item), :action => :show
          return
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    if !current_user.can_delete(@comment)
      render :nothing => true, :status => :forbidden
    else
      @comment.has_been_deleted = true;
      if @comment.save
        logger.debug("OMG!!!")
        flash[:notice] = 'Comment was successfully deleted.'
        redirect_to url_for(@comment.original_comment_item), :action => :show
        return
      else
        flash[:notice] = 'Comment was unable to be deleted, internal rails error.'
        redirect_to url_for(@comment.original_comment_item), :action => :show
        return 
      end
    end
  end
  
  def lock
    @comment = Comment.find_by_id(params[:id])
    if @comment.can_user_lock(current_user)
      @comment.has_been_locked = true
      if @comment.save 
        flash[:notice] = "Comment was successfully locked."
      else
        flash[:alert] = "Comment was not locked, internal rails error."
      end
      redirect_to :back
      return
    end
    render :nothing => true, :status => :forbidden
  end
  
  def unlock
    @comment = Comment.find_by_id(params[:id])
    if @comment.can_user_lock(current_user)
      @comment.has_been_locked = false
      if @comment.save 
        flash[:notice] = "Comment was successfully unlocked."
      else
        flash[:alert] = "Comment was not unlocked, internal rails error."
      end
      redirect_to :back
      return
    end
    render :nothing => true, :status => :forbidden
  end
end
