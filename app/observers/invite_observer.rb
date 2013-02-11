###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for Invite.
###
class InviteObserver < ActiveRecord::Observer
  ###
  # Notify user of new message if they have that option set.
  ###
  def after_create(invite)
    unless Rails.env.test?
      if invite.user_profile.is_email_on_invite
        InviteMailer.delay.new_invite(invite.id)
      end
    end
  end
end
