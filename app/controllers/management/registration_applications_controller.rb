class Management::RegistrationApplicationsController < ApplicationController
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
  
  # GET /registration_applications/1/edit
  def edit
    @registration_application = RegistrationApplication.find(params[:id])
  end

  # PUT /registration_applications/1
  # PUT /registration_applications/1.xml
  def update
    @registration_application = RegistrationApplication.find(params[:id])

    respond_to do |format|
      if @registration_application.update_attributes(params[:registration_application])
        add_new_flash_message('Registration application was successfully updated.')
        format.html { redirect_to(@registration_application) }
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
      ApplicationNotifier.accept_notification(@registration_application).deliver
      
      add_new_flash_message('Registration application was successfully accepted.')
      add_new_flash_message("#{@registration_application.name} has been sent an email updating them on the decision.")
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
      ApplicationNotifier.reject_notification(@registration_application).deliver      

      add_new_flash_message('Registration application was successfully rejected.')
      add_new_flash_message("#{@registration_application.name} has been sent an email updating them on the decision.")
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
    if @registration_application.destroy
      add_new_flash_message('Registration application was successfully deleted.')
    end  
    
    respond_to do |format|
      format.html { redirect_to(registration_applications_url) }
      format.xml  { head :ok }
    end
  end
end
