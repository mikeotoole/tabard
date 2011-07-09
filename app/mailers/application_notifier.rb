class ApplicationNotifier < ActionMailer::Base
  default :from => "noreply@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.application_notifier.email_applicant.subject
  #
  def email_applicant(registration_application)
    @thankyou = registration_application.thankyou_message

    mail(:to => registration_application.applicant_email, :subject=> "Application Received" )
  end
  
  def accept_notification(registration_application)
    #TODO we will need to add these from some global variable
    @community_name = registration_application.community_name
    @applicant = registration_application.name
    
    mail(:to => registration_application.applicant_email, :subject=> "Application Accepted" )
  end
  
  def reject_notification(registration_application)
    #TODO we will need to add these from some global variable
    @community_name = registration_application.community_name
    @applicant = registration_application.name

    mail(:to => registration_application.applicant_email, :subject=> "Application Rejected" )
  end
end
