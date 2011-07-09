class UserMailer < ActionMailer::Base
  default :from => "noreply@crumblin.com"
  
  def welcome_email(user)
    @user = user
    @user_profile = @user.user_profile
    mail(:to => @user.email, :subject=> "Welcome to Crumblin.com" )
  end
end
