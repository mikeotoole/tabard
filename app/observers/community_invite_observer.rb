###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for CommunityInvite.
###
class CommunityInviteObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers
  ###
  # Notify user of new invite.
  ###
  def after_create(community_invite)
    unless Rails.env.test?
      default_url_options[:host] = Rails.env.production? ? "tabard.co" : "lvh.me:3000"

      if community_invite.applicant.blank?
        CommunityInviteMailer.delay.new_community_invite(community_invite.id)
      else
        send_message(community_invite)
      end
    end
  end

  def after_update(community_invite)
    unless Rails.env.test?
      default_url_options[:host] = Rails.env.production? ? "tabard.co" : "lvh.me:3000"

      if community_invite.applicant_id_changed?
        send_message(community_invite, true)
      end
    end
  end

  def send_message(community_invite, no_email=false)
    Message.create_system(subject: "You have been invited to #{community_invite.community_name}",
                             body: "#{community_invite.sponsor_display_name} has invited you to [join the \"#{community_invite.community_name}\" community](#{new_community_application_url(subdomain: community_invite.community_subdomain)}).",
                               to: [community_invite.applicant_id],
                  dont_send_email: no_email)
  end
end
