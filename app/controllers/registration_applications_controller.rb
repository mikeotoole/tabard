class RegistrationApplicationsController < CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:new, :create, :show]

  # GET /registration_applications/new
  # GET /registration_applications/new.xml
  def new
    @registration_application = RegistrationApplication.new
    @profile = UserProfile.new 
    @user = User.new
    
    @registration_application.site_form = @community.community_application_form
    #@registration_application.answers.build if @registration_application.answers.count == 0
    
    @games = @community.games.active

    add_new_flash_message(@registration_application.site_form.message)
    respond_with(@registration_application)
  end

  # POST /registration_applications
  # POST /registration_applications.xml
  def create
    if logged_in?
      @user = current_user
      @profile = current_user.user_profile
    else
      @user = User.new(params[:user])
      @profile = @user.build_user_profile(params[:user_profile])        
    end
    @registration_application = @profile.build_registration_application(params[:registration_application])
    
    @registration_application.set_applicant
    
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
    @registration_application.answers.clear
    if params[:answer_helper]
      @answer_helper = params[:answer_helper]
      params[:answer_helper].each do |question_id, question|
        question.each do |answer_id, answer|
          @registration_application.answers << Answer.new(:question_id => question_id, :content => answer)
        end  
      end
    end

      if @user.save and @profile.save and @registration_application.save   
        #add_new_flash_message('Registration application was successfully submitted.') Removed for BVR-152
        add_new_flash_message(@registration_application.site_form.thankyou)
        @registration_application.user_profile.user.roles << @registration_application.applicant_role
      else
        @games = Game.active
      end
      respond_with(@registration_application)
  end
end
