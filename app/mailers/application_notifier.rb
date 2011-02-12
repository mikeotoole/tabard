class ApplicationNotifier < ActionMailer::Base
  default :from => "brutal_venom@digitalaugment.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.application_notifier.email_applicant.subject
  #
  def email_applicant(registration_application)
    @greeting = "Hi"

    mail(:to => registration_application.applicant_email, :subject=> "Welcome to brutal venom")
  end
end
