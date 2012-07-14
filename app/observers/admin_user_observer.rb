###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for AdminUser.
###
class AdminUserObserver < ActiveRecord::Observer
  ###
  # notify user and send password setup instructions.
  ###
  def after_create(admin_user)
    unless Rails.env.test?
      random_password = AdminUser.send(:generate_token, 'encrypted_password').slice(0, 8)
      admin_user.password = random_password
      admin_user.reset_password_token = AdminUser.reset_password_token
      admin_user.reset_password_sent_at = Time.now
      admin_user.save(validate: false)
      UserMailer.setup_admin(AdminUser.find(admin_user), random_password).deliver
    end
  end
end
