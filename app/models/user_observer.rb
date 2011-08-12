=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a user observer.
=end
class UserObserver < ActiveRecord::Observer
  
=begin
  _after_create_

  This method sends out an email to welcome the user, unless the user has no_signup_email set to true.
  [Returns] True is successful, otherwise false.
=end
  def after_create(user)
    UserMailer.welcome_email(user).deliver unless user.no_signup_email
  end
end
