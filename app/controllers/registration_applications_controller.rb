class RegistrationApplicationsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:new, :create]
  
  # GET /registration_applications
  # GET /registration_applications.xml
  def index
    @registration_applications = RegistrationApplication.all
  
    @form = SiteForm.application_form

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
    @profile = UserProfile.new 
    @user = User.new
    
    @registration_application.site_form = SiteForm.application_form
    @registration_application.answers.build if @registration_application.answers.count == 0

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
    
    @profile.set_applicant

    # Force errors to display if @profile.valid? fails in the if statement
    @registration_application.valid?
    @user.valid?

    respond_to do |format|
      if @profile.valid? && @user.valid? && @registration_application.valid?
        @user.save
        @profile.user_id = @user.id
        @profile.save
        @registration_application.user_profile_id = @profile.id
        @registration_application.save
        
        format.html { redirect_to root_path, :notice => 'Registration application was successfully submitted. Confirmation emailed.' }
        format.xml  { render :xml => @registration_application, :status => :created, :location => @registration_application }
      else
        @registration_application.answers.build if @registration_application.answers.count == 0
        format.html { render :action => "new" }#, :object => @registration_application }
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
  
  # POST /registration_applications/1/accept
  # POST /registration_applications/1/accept.xml
  def accept
    @registration_application = RegistrationApplication.find(params[:id])
    @registration_application.user_profile.set_active
    
    if @registration_application.user_profile.save
      #TODO Need to email applicant
      flash[:notice] = 'Registration application was successfully accepted.'
      respond_with(@registration_application)
    else
      flash[:alert] = @registration_application.errors
      respond_with(@registration_application)
    end
  end

  # POST /registration_applications/1/reject
  # POST /registration_applications/1/reject.xml  
  def reject
    @registration_application = RegistrationApplication.find(params[:id])
    @registration_application.user_profile.set_rejected
    
    if @registration_application.user_profile.save
      #TODO Need to email applicant
      flash[:notice] = 'Registration application was successfully rejected.'
      respond_with(@registration_application)
    else
      flash[:alert] = @registration_application.errors
      respond_with(@registration_application)
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
