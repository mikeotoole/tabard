class Management::RegistrationApplicationsController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate, :except => [:new, :create]

  def index
    @registration_applications = @community.registration_applications.all
    @form = @community.community_application_form
    respond_with(@registration_applications)
  end

  def show
    @registration_application = @community.registration_applications.find(params[:id])
    respond_with(@registration_application)
  end

  def edit
    @registration_application = @community.registration_applications.find(params[:id])
  end

  def update
    @registration_application = @community.registration_applications.find(params[:id])
    # TODO Add permission checking - JW
    if @registration_application.update_attributes(params[:registration_application])
      add_new_flash_message('Registration application was successfully updated.')
    end
    grab_all_errors_from_model(@registration_application)
    respond_with(@registration_application)
  end

  def accept
    @registration_application = RegistrationApplication.find(params[:id])
    @registration_application.set_accepted
    # TODO Add permission checking - JW
    if @registration_application.save
      ApplicationNotifier.accept_notification(@registration_application).deliver  
      add_new_flash_message('Registration application was successfully accepted.')
      add_new_flash_message("#{@registration_application.name} has been sent an email updating them on the decision.")
    end
    grab_all_errors_from_model(@registration_application)
    render "show"
  end

  def reject
    @registration_application = RegistrationApplication.find(params[:id])
    @registration_application.set_rejected
    # TODO Add permission checking - JW
    if @registration_application.save
      ApplicationNotifier.reject_notification(@registration_application).deliver      
      add_new_flash_message('Registration application was successfully rejected.')
      add_new_flash_message("#{@registration_application.name} has been sent an email updating them on the decision.")
    end
    grab_all_errors_from_model(@registration_application)
    render "show"
  end

  def destroy
    @registration_application = @community.registration_applications.find(params[:id])
    if @registration_application.destroy
      add_new_flash_message('Registration application was successfully deleted.')
      redirect_to(registration_applications_url)
    else
      grab_all_errors_from_model(@registration_application)
      respond_with(@registration_application)
    end
  end
end
