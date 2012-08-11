###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used to send community invite emails to non users..
###
class CommunityInviteMailer < ActionMailer::Base
  default from: "Guild.io <noreply@guild.io>",
          content_type: "text/html"
  layout 'mailer'

  # Tell a non guild.io user they have been invited to join a community.
  def new_community_invite(invite_id)
    @invite = CommunityInvite.find_by_id(invite_id)
    if !!@invite
      mail(to: @invite.email, subject: "Guild.io - #{@invite.sponsor_display_name} invited you to join thier community") do |format|
         format.html { render "mailers/new_community_invite" }
      end
    end
  end
end