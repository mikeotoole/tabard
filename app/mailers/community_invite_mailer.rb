###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used to send community invite emails to non users..
###
class CommunityInviteMailer < ActionMailer::Base
  default from: "Tabard <noreply@tabard.co>",
          content_type: "text/html"
  layout 'mailer'

  # Tell a non Tabard user they have been invited to join a community.
  def new_community_invite(invite_id)
    @invite = CommunityInvite.find_by_id(invite_id)
    if @invite.present? and @invite.email.present?
      mail(to: @invite.email, subject: "Tabard: #{@invite.sponsor_display_name} invited you to join thier community") do |format|
         format.html { render "mailers/new_community_invite" }
      end
    end
  end
end