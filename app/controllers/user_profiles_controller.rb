class UserProfilesController < ProfilesController
  before_filter :authenticate  
    
  # GET /user_profiles
  # GET /user_profiles.xml
  def index
    @profiles = Profile.find(:all, :conditions => { :type => 'UserProfile' })

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end    

  # GET /user_profiles/1
  # GET /user_profiles/1.xml
  def show
    @profile = Profile.find(params[:id])
    
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @profile }
      end
  end

  # GET /user_profiles/new
  # GET /user_profiles/new.xml
  def new
    add_new_flash_message("Please create a user profile to finish creating your account.","alert")
    @profile = UserProfile.new
    @profile.type = "UserProfile"
    @profile.user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end
  
  # GET /user_profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end

  # POST /user_profiles
  # POST /user_profiles.xml
  def create
    if @profile == nil
      logger.debug "profile was nil"
      @profile = UserProfile.new(params[:profile])
      @profile.user = current_user
    else
      @profile.update_attributes(params[:profile])
    end

    respond_to do |format|
      if @profile.save
        add_new_flash_message('Profile was successfully created.')
        format.html { redirect_to(@profile) }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_profiles/1
  # PUT /user_profiles/1.xml
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        add_new_flash_message('Profile was successfully updated.')
        format.html { redirect_to(@profile) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_profiles/1
  # DELETE /user_profiles/1.xml
  def destroy
    @profile = Profile.find(params[:id])
    if @profile.destroy
      add_new_flash_message('Profile was successfully deleted.')
    end

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
      format.xml  { head :ok }
    end
  end  
  
end