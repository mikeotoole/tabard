class RegistrationApplicationObserver < ActiveRecord::Observer
  def after_create(registration_application)
    #logger.debug(registration_application.to_s)
    ApplicationNotifier.email_applicant(registration_application).deliver
    ApplicationNotifier.email_community_leader(registration_application).deliver if registration_application.community.email_notice_on_applicant
  end
end
