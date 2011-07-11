class ApplicationNotifier < ActionMailer::Base
  default :from => "noreply@crumblin.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.application_notifier.email_applicant.subject
  #
  def email_applicant(registration_application)
    @thankyou = registration_application.thankyou_message
    @community_name = registration_application.community_name

    mail(:to => registration_application.applicant_email, :subject=> "Application Received for #{@community_name}" )
  end
  
  def email_community_leader(registration_application)
    @applicant_profile = registration_application.user_profile
    @leader_profile = registration_application.community.leader_profile
    @community = registration_application.community
    mail(:to => registration_application.applicant_email, :subject=> "#{@leader_profile.display_name}, you have a new applicant for #{@community.display_name}" )
  end
  
  def accept_notification(registration_application)
    @community_name = registration_application.community_name
    @applicant = registration_application.name
    
    mail(:to => registration_application.applicant_email, :subject=> "Application Accepted" )
  end
  
  def reject_notification(registration_application)
    @community_name = registration_application.community_name
    @applicant = registration_application.name

    mail(:to => registration_application.applicant_email, :subject=> "Application Rejected" )
  end
end
