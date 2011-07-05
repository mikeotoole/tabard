class RegistrationApplicationsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:new, :create]

  # GET /registration_applications/new
  # GET /registration_applications/new.xml
  def new
    @registration_application = RegistrationApplication.new
    @profile = UserProfile.new 
    @user = User.new
    
    @registration_application.site_form = SiteForm.application_form
    #@registration_application.answers.build if @registration_application.answers.count == 0
    
    @games = Game.active

    add_new_flash_message(@registration_application.site_form.message)
    respond_with(@registration_application)
  end

  # POST /registration_applications
  # POST /registration_applications.xml
  def create
    @user = User.new(params[:user])
    @profile = @user.build_user_profile(params[:user_profile])
    @registration_application = @profile.build_registration_application(params[:registration_application])
    
    @profile.set_applicant
    
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

    respond_to do |format|
      if @user.save      
        #add_new_flash_message('Registration application was successfully submitted.') Removed for BVR-152
        add_new_flash_message(@registration_application.site_form.thankyou)
        format.html { redirect_to root_path }
        format.xml  { render :xml => @registration_application, :status => :created, :location => @registration_application }
      else
        @games = Game.active
        #@registration_application.answers.clear
        #@registration_application.answers.build if @registration_application.answers.count == 0
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration_application.errors, :status => :unprocessable_entity }
      end
    end
  end
end
