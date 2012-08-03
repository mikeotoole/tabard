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
      default_url_options[:host] = ENV["RAILS_ENV"] == 'production' ? "guild.io" : "lvh.me:3000"
      Message.create_system(subject: "You have been invited to #{community_invite.community_name}",
                    body: "#{community_invite.sponsor_display_name} has invited you to [#{community_invite.community_name}](#{root_url(subdomain: community_invite.community_subdomain)}). You can apply [here](#{new_community_application_url(subdomain: community_invite.community_subdomain)})",
                    to: [community_invite.applicant_id])
    end
  end
end
