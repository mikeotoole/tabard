class RegistrationApplicationObserver < ActiveRecord::Observer
  def after_create(registration_application)
    #logger.debug(registration_application.to_s)
    if false
      ApplicationNotifier.email_applicant(registration_application).deliver
      ApplicationNotifier.email_community_leader(registration_application).deliver if registration_application.community.email_notice_on_applicant
    end
    registration_application.user_profile.user.roles << registration_application.applicant_role
  end
end
