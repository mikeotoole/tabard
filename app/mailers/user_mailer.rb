###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the admin portal for sending password reset and new Admin emails.
###
class UserMailer < ActionMailer::Base # TODO Doug, Update all subjects as needed. -MO
  default :from => "noreply@crumblin.com",
          :content_type => "text/html"

  # Used for resetting a single users password.
  def password_reset(user, password=nil)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin Password Reset Notification', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/reset_password_by_admin_instructions" }
    end
  end

  # Used for resetting all users passwords.
  def all_password_reset(user, password=nil)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin Password Reset Notification', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/reset_all_password_by_admin_instructions" }
    end
  end

  # Used for creating a new AdminUser.
  def setup_admin(user, password=nil)
    @resource = user
    mail(:to => @resource.email, :subject => 'New Crumblin Admin Created', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/new_admin_user_setup_instructions" }
    end
  end

  # Used for reinstating an account.
  def reinstate_account(user, password=nil)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin Reinstate Account Notification', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/reinstate_account_instructions" }
    end
  end
end
