class RegistrationApplicationObserver < ActiveRecord::Observer
  def after_create(registration_application)
    #logger.debug(registration_application.to_s)
    ApplicationNotifier.email_applicant(registration_application).deliver
    
    #Setup the discussion
    registration_application.discussion = Discussion.create(:name => "Application for: "+registration_application.name, :body => "Please feel free to discuss our new applicant.", :discussion_space => DiscussionSpace.registration_application_space)
    logger.error("Oh no registration application not getting discussion") unless registration_application.save
  end
end
