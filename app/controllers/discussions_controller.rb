class DiscussionsController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate
  
  # GET /discussions/1
  # GET /discussions/1.xml
  def show
    @discussion = Discussion.find(params[:id])
    if !current_user.can_show(@discussion)
      render_insufficient_privileges
    else
      respond_with(@discussion)
    end
  end

  # GET /discussions/1/edit
  def edit
    @discussion = Discussion.find(params[:id])
    if !current_user.can_update(@discussion)
      render_insufficient_privileges
    end
  end

  # PUT /discussions/1
  # PUT /discussions/1.xml
  def update
    @discussion = Discussion.find(params[:id])
    if !current_user.can_update(@discussion)
      render_insufficient_privileges
    else
      if @discussion.update_attributes(params[:discussion])
        add_new_flash_message('Discussion was successfully updated.')
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
      render_insufficient_privileges
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
        add_new_flash_message("Discussion was successfully locked.")
      else
        add_new_flash_message("Discussion was not locked, internal rails error.", 'alert')
      end
      redirect_to :back
      return
    end
    render_insufficient_privileges
  end
  
  def unlock
    @discussion = Discussion.find_by_id(params[:id])
    if @discussion.can_user_lock(current_user)
      @discussion.has_been_locked = false
      if @discussion.save 
        add_new_flash_message("Discussion was successfully unlocked.")
      else
        add_new_flash_message("Discussion was not unlocked, internal rails error.", 'alert')
      end
      redirect_to :back
      return
    end
    render_insufficient_privileges
  end
end
