class UsersController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:new, :create, :show]
  # GET /users/1
  # GET /users/1.xml
  def show
    if !current_user.can_show("User") and User.find(params[:id]) != current_user
      render_insufficient_privileges
    else 
      @user = User.find(params[:id])
      @acknowledgment_of_announcements = @user.unacknowledged_announcements
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end
  
  # GET /registration_applications/new
  # GET /registration_applications/new.xml
  def new
    @profile = UserProfile.new 
    @user = User.new
    
    @games = Game.active

    add_new_flash_message("Please fill this form out to join Crumblin")
    respond_with(@user)
  end

  # POST /registration_applications
  # POST /registration_applications.xml
  def create
    @user = User.new(params[:user])
    @profile = @user.build_user_profile(params[:user_profile])
    
    if params[:wow_character]
      @wowCharacters = Array.new
      params[:wow_character].each do |character|
        newWow = WowCharacter.new(character.last)
        @wowCharacters << newWow
        @profile.build_character(newWow)
      end
    end
    
    if params[:swtor_character]
      @swtorCharacters = Array.new
      params[:swtor_character].each do |character|
        newSwtor = SwtorCharacter.new(character.last)
        @swtorCharacters << newSwtor
        @profile.build_character(newSwtor)
      end
    end

    if @user.save 
      add_new_flash_message('You have successfully created your new Crumblin user.')
      add_new_flash_message("Welcome, <em>#{@user.name}</em>.")
      session[:user_id] = @user.id
    else
      @games = Game.active
    end
    respond_with(@user)
  end
end
