class UserProfilesController < ProfilesController
  respond_to :html 
  before_filter :authenticate  

  def index
    @profiles = UserProfile.find(:all, :conditions => { :type => 'UserProfile' })
    respond_with(@profile)
  end    

  def show
    @profile = UserProfile.find(params[:id])    
    respond_with(@profile)
  end

  def new
    add_new_flash_message("Please create a user profile to finish creating your account.","alert")
    @profile = UserProfile.new
    @profile.user = current_user
    respond_with(@profile)
  end
  
  def edit
    @profile = UserProfile.find(params[:id])
    respond_with(@profile)
  end

  def create
    @profile = UserProfile.new(params[:profile])
    @profile.user = current_user      
    if @profile.save
      add_new_flash_message('Profile was successfully created.')
    end
    grab_all_errors_from_model(@profile)
    respond_with(@profile)
  end

  def update
    @profile = UserProfile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      add_new_flash_message('Profile was successfully updated.')
      add_new_flash_message("#{@profile.errors.to_s} !!!!!!")
      add_new_flash_message("#{@profile.avatar_url.to_s} !!!!!!")
    else
      grab_all_errors_from_model(@profile)
    end
    render :show
  end

  def destroy
    @profile = UserProfile.find(params[:id])
    if @profile.destroy
      add_new_flash_message('Profile was successfully deleted.')
    end
    respond_with(@profile)
  end  
end