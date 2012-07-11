###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the admin portal for sending password reset and new Admin emails.
###
class UserMailer < ActionMailer::Base
  default :from => "Crumblin <noreply@crumblin.com>",
          :content_type => "text/html"
  layout 'mailer'

  # Used for resetting a single users password.
  def password_reset(user, password=nil)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin - Password reset notification', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/reset_password_by_admin_instructions" }
    end
  end

  # Used for creating a new AdminUser.
  def setup_admin(user, password=nil)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin - New admin account', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/new_admin_user_setup_instructions" }
    end
  end

  # Used for reinstating an account.
  def reinstate_account(user, password=nil)
    @resource = user
    mail(:to => @resource.email, :subject => 'Crumblin - Reinstate Account Notification', :tag => 'password-reset') do |format|
       format.html { render "devise/mailer/reinstate_account_instructions" }
    end
  end

  # Notifies the user that their password has changed.
  def password_changed(user_id)
    @resource = User.find_by_id(user_id)
    mail(:to => @resource.email, :subject => 'Crumblin - Password has been changed') do |format|
       format.html { render "devise/mailer/password_changed" }
    end
  end
end