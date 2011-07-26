class Subdomains::CommentsController < SubdomainsController
  respond_to :html, :js
  before_filter :authenticate

  def index
    @comments = Comment.all
    respond_with(@comments)
  end

  def show
    @comment = Comment.find(params[:id])
    if !current_user.can_show(@comment)
      render_insufficient_privileges
    else
      respond_with(@comment)
    end
  end

  def new
    @comment = Comment.new
    if !current_user.can_create(@comment)
      render_insufficient_privileges
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

  def edit
    @comment = Comment.find(params[:id])
    if !current_user.can_update(@comment)
      render_insufficient_privileges
    end
    respond_with(@comment)
  end

  def create
    @comment = Comment.new(params[:comment])
    if !current_user.can_create(@comment)
      render_insufficient_privileges
    else
      if @comment.save
        add_new_flash_message('Comment was successfully created.')
        #redirect_to(:back)
        respond_with(@comment)
      else
        grab_all_errors_from_model(@comment)
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
          format.js { render 'fail_create.js.erb' }
        end
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if !current_user.can_update(@comment)
      render_insufficient_privileges
    else
      @comment.has_been_edited = true
      if @comment.update_attributes(params[:comment])
        add_new_flash_message('Comment was successfully updated.')
        redirect_to url_for(@comment.original_comment_item), :action => :show
        return
      else
        grab_all_errors_from_model(@comment)
        respond_with(@comment)
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if !current_user.can_delete(@comment)
      render_insufficient_privileges
    else
      @comment.has_been_deleted = true;
      if @comment.save
        add_new_flash_message('Comment was successfully deleted.')
        redirect_to url_for(@comment.original_comment_item), :action => :show
        return
      else
        add_new_flash_message('Comment was unable to be deleted, internal rails error.')
        redirect_to url_for(@comment.original_comment_item), :action => :show
        return 
      end
    end
  end
  
  def lock
    @comment = Comment.find_by_id(params[:id])
    if !@comment.can_user_lock(current_user)
      render_insufficient_privileges
    else
      @comment.has_been_locked = true
      if @comment.save 
        add_new_flash_message("Comment was successfully locked.")
      else
        add_new_flash_message("Comment was not locked, internal rails error.")
      end
      redirect_to :back
      return
    end
  end
  
  def unlock
    @comment = Comment.find_by_id(params[:id])
    if !@comment.can_user_lock(current_user)
      render_insufficient_privileges
    else
      @comment.has_been_locked = false
      if @comment.save 
        add_new_flash_message("Comment was successfully unlocked.")
      else
        add_new_flash_message("Comment was not unlocked, internal rails error.")
      end
      redirect_to :back
      return
    end
  end
end
