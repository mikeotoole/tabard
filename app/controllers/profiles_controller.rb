class ProfilesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate  
  
  # GET /profiles
  # GET /profiles.xml
  def index
    @profiles = Profile.all
    @user_profiles = Profile.find(:all, :conditions => { :type => 'UserProfile' })
    @game_profiles = Profile.find(:all, :conditions => { :type => 'GameProfile' })
    
    respond_with(@profiles, @site_profiles, @game_profiles)
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = Profile.find(params[:id])
    if @profile.game_id != nil
      @game = Game.find(@profile.game_id)
    end
    
    if @profile.type == "GameProfile"
      respond_to do |format|
        format.html { render :file => 'profiles/showgame' }
        format.xml  { render :xml => @profile }
      end
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @profile }
      end
    end
  end

  # GET /profiles/new
  # GET /profiles/new.xml
  def new
    if @profile_type == "UserProfile" || current_user.user_profile == nil || @profile_type == nil
      flash.now[:alert] = "Please create a user profile to finish creating your account."
      @profile = UserProfile.new
      @profile.type = "UserProfile"
    else
      flash.now[:alert] = "Please create a game profile."
      @profile = GameProfile.new
      @profile.type = "GameProfile"
    end
    @profile.user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.xml
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
        format.html { redirect_to(@profile, :notice => 'Profile was successfully created.') }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to(@profile, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.xml
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
      format.xml  { head :ok }
    end
  end
end