class RegistrationApplicationObserver < ActiveRecord::Observer
  def after_create(registration_application)
    #logger.debug(registration_application.to_s)
    ApplicationNotifier.email_applicant(registration_application).deliver
  end
end
