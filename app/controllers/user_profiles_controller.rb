class UserProfilesController < ProfilesController
  respond_to :html, :xml  
  before_filter :authenticate  
    
  # GET /user_profiles
  # GET /user_profiles.xml
  def index
    @profiles = UserProfile.find(:all, :conditions => { :type => 'UserProfile' })

    respond_with(@profile)
  end    

  # GET /user_profiles/1
  # GET /user_profiles/1.xml
  def show
    @profile = UserProfile.find(params[:id])
    
    respond_with(@profile)
  end

  # GET /user_profiles/new
  # GET /user_profiles/new.xml
  def new
    add_new_flash_message("Please create a user profile to finish creating your account.","alert")
    @profile = UserProfile.new
    @profile.user = current_user
    respond_with(@profile)
  end
  
  # GET /user_profiles/1/edit
  def edit
    @profile = UserProfile.find(params[:id])
    respond_with(@profile)
  end

  # POST /user_profiles
  # POST /user_profiles.xml
  def create
      @profile = UserProfile.new(params[:profile])
      @profile.user = current_user
      
    if @profile.save
      add_new_flash_message('Profile was successfully created.')
    else
      grab_all_errors_from_model(@profile)
    end
    respond_with(@profile)
  end

  # PUT /user_profiles/1
  # PUT /user_profiles/1.xml
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

  # DELETE /user_profiles/1
  # DELETE /user_profiles/1.xml
  def destroy
    @profile = UserProfile.find(params[:id])
    if @profile.destroy
      add_new_flash_message('Profile was successfully deleted.')
    end

    respond_with(@profile)
  end  
  
end