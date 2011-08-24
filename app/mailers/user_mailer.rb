=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This notifier is for emailing based around users.
=end
class UserMailer < ActionMailer::Base
  default :from => "noreply@crumblin.com"

  def welcome_email(user)
    @user = user
    @user_profile = @user.user_profile
    mail(:to => @user.email, :subject=> "Welcome to Crumblin.com" )
  end
end
