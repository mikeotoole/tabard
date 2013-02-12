###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2013 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the InviteObserver to send emails.
###
class InviteMailer < ActionMailer::Base
  default from: "Tabard <noreply@#{ENV['BV_HOST_DOMAIN']}>",
          content_type: "text/html"
  layout 'mailer'

  # Tell user they have a new message
  def new_invite(invite_id)
    @invite = Invite.find_by_id(invite_id)
    @event = @invite.event
    if !!@invite
      @subject = "Tabard: New Event Invite For #{@invite.community_name}"
      @user_profile = @invite.user_profile
      mail(to: @user_profile.email, subject: @subject) do |format|
         format.html { render "mailers/new_invite" }
      end
    end
  end
end
