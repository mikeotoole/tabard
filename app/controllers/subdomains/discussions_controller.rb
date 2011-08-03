=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is handling discussions within the scope of subdomains (communities).
=end
class Subdomains::DiscussionsController < SubdomainsController
  respond_to :html
  before_filter :authenticate

  def show
    @discussion = Discussion.find(params[:id])
    if !current_user.can_show(@discussion)
      render_insufficient_privileges
    else
      respond_with(@discussion)
    end
  end

  def edit
    @discussion = Discussion.find(params[:id])
    if !current_user.can_update(@discussion)
      render_insufficient_privileges
    end
  end

  def update
    @discussion = Discussion.find(params[:id])
    if !current_user.can_update(@discussion)
      render_insufficient_privileges
    else
      if @discussion.update_attributes(params[:discussion])
        add_new_flash_message('Discussion was successfully updated.')
      end
      grab_all_errors_from_model(@discussion)
      respond_with(@discussion)
    end
  end

  def destroy
    @discussion = Discussion.find(params[:id])
    if !current_user.can_delete(@discussion)
      render_insufficient_privileges
    else 
      @discussion.destroy
      grab_all_errors_from_model(@discussion)
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
