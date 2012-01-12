###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the admin portal for sending password reset and new Admin emails.
###
class UserMailer < ActionMailer::Base
  default :from => "noreply@crumblin.com",
          :content_type => "text/html"

  # Used for resetting a single users password.
  def password_reset(user, password)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin - Password reset notification', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/reset_password_by_admin_instructions" }
    end
  end

  # Used for resetting all users passwords.
  def all_password_reset(user, password)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin - Password reset notification', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/reset_all_password_by_admin_instructions" }
    end
  end

  # Used for creating a new AdminUser.
  def setup_admin(user, password)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin - New admin account', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/new_admin_user_setup_instructions" }
    end
  end
end
