class RegistrationApplicationsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  
  # GET /registration_applications
  # GET /registration_applications.xml
  def index
    @registration_applications = RegistrationApplication.all
  
    #TODO need to get the registration form. Becouse of the seed it is the first one. There should be a better way to insure this however.
    @form = SiteForm.first

    respond_with(@registration_applications)
  end

  # GET /registration_applications/1
  # GET /registration_applications/1.xml
  def show
    @registration_application = RegistrationApplication.find(params[:id])

    respond_with(@registration_application)
  end

  # GET /registration_applications/new
  # GET /registration_applications/new.xml
  def new
    @registration_application = RegistrationApplication.new
    #TODO need to get the current registration form. Becouse of the seed it is the first one. There should be a better way to insure this however.
    @form = SiteForm.first
    @registration_application.registration_answers.build

    @characters = Character.new

    respond_with(@registration_application)
  end

  # GET /registration_applications/1/edit
  def edit
    @registration_application = RegistrationApplication.find(params[:id])
  end

  # POST /registration_applications
  # POST /registration_applications.xml
  def create
    
    @registration_application = RegistrationApplication.new(params[:registration_application])
    @user = User.new(params[:user])
    @profile = UserProfile.new(params[:user_profile])
    
    @user.is_applicant = true
    @user.is_active = false
    @user.save
    @profile.user_id = @user.id
    @profile.save
    @registration_application.user_profile_id = @profile.id

    respond_to do |format|
      if @registration_application.save
        format.html { redirect_to(@registration_application, :notice => 'Registration application was successfully created.') }
        format.xml  { render :xml => @registration_application, :status => :created, :location => @registration_application }
      else    
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registration_applications/1
  # PUT /registration_applications/1.xml
  def update
    @registration_application = RegistrationApplication.find(params[:id])

    respond_to do |format|
      if @registration_application.update_attributes(params[:registration_application])
        format.html { redirect_to(@registration_application, :notice => 'Registration application was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_applications/1
  # DELETE /registration_applications/1.xml
  def destroy
    @registration_application = RegistrationApplication.find(params[:id])
    @registration_application.destroy

    respond_to do |format|
      format.html { redirect_to(registration_applications_url) }
      format.xml  { head :ok }
    end
  end
end
