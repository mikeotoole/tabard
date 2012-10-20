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
      default_url_options[:host] = ENV["RAILS_ENV"] == 'production' ? "tabard.co" : "lvh.me:3000"

      if community_invite.applicant.blank?
        CommunityInviteMailer.delay.new_community_invite(community_invite.id)
      else
        Message.create_system(subject: "You have been invited to #{community_invite.community_name}",
                      body: "#{community_invite.sponsor_display_name} has invited you to [join the \"#{community_invite.community_name}\" community](#{new_community_application_url(subdomain: community_invite.community_subdomain)}).",
                      to: [community_invite.applicant_id])
      end
    end
  end
end
