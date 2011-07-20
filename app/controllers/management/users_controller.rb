# TODO This controller needs permissions -JW
class Management::UsersController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate

  def index
    if !current_user.can_show("User") 
      render_insufficient_privileges
    else 
      @users = User.all
      respond_with([:management, @users])
    end
  end

#  def show
#    if !current_user.can_show("User") and User.find(params[:id]) != current_user
#      render :nothing => true, :status => :forbidden
#    else 
#      @user = User.find(params[:id])
#      @announcements = Announcement.all
#      
#      respond_to do |format|
#        format.html # show.html.erb
#        format.xml  { render :xml => @user }
#      end
#    end
#  end

  def destroy
    if !current_user.can_delete("User") 
      render_insufficient_privileges
    else 
      @user = User.find(params[:id])
      #@user.destroy # TODO Remove from communit
    end
  end
  
  # activate
  #f !current_user.can_update("User") and User.find(params[:id]) != current_user
  # render_insufficient_privileges
  #lse 
  # @user = User.find(params[:id])
  # @user.user_profile.set_active
  # 
  # respond_to do |format|
  #   if @user.user_profile.save
  #     add_new_flash_message('User was successfully activated.')
  #     format.html { redirect_to(management_users_path) }
  #     format.xml  { head :ok }
  #   else
  #     add_new_flash_message('Error making active.')
  #     format.html { redirect_to(management_users_path) }
  #     format.xml  { render :xml => @user.user_profile.errors, :status => :unprocessable_entity }
  #   end
  # end
  #nd
  #
  #
  # deactivate
  #f !current_user.can_update("User") and User.find(params[:id]) != current_user
  # render_insufficient_privileges
  #lse 
  # @user = User.find(params[:id])
  # @user.user_profile.set_inactive
  # 
  # respond_to do |format|
  #   if @user.user_profile.save
  #     add_new_flash_message('User was successfully deactivated.')
  #     format.html { redirect_to(management_users_path) }
  #     format.xml  { head :ok }
  #   else
  #     add_new_flash_message('Error making inactive.',"alert")
  #     format.html { redirect_to(management_users_path) }
  #     format.xml  { render :xml => @user.user_profile.errors, :status => :unprocessable_entity }
  #   end
  # end
  #nd
  #
end
