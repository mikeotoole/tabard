=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a user observer.
=end
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.welcome_email(user).deliver unless user.no_signup_email
  end
end
