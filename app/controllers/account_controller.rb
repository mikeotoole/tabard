class AccountController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:new, :create, :show]
  before_filter :get_all_active_games 
  def new
    @profile = UserProfile.new 
    @user = User.new

    add_new_flash_message("Please fill this form out to create your Crumblin account.")
    respond_with(@user, @profile, @games)
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
    end
    respond_with(@user, @profile, @games)
  end
  
  def edit
    @user = current_user
    @profile = current_user.user_profile
    @wowCharacters = current_user.get_characters(Wow)
    @swtorCharacters = current_user.get_characters(Swtor)   
    respond_with(@user, @profile, @games, @wowCharacters, @swtorCharacters)
  end

  def update
  end

  def show
    if not logged_in?
      redirect_to signup_path
    else
      @user = current_user
      @profile = current_user.user_profile
      respond_with(@user, @profile, @games)
    end
  end

  def destroy
    @user = current_user
    @profile = current_user.user_profile
    respond_with(@user, @profile, @games)
  end

  def get_all_active_games
    @games = Game.active
  end
end
