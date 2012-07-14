###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the Acknowledgement to send emails.
###
class AcknowledgementMailer < ActionMailer::Base
  default :from => "Crumblin <noreply@crumblin.com>",
          :content_type => "text/html"
  layout 'mailer'

  # Tell user they have a new message
  def new_acknowledgement(acknowledgement_id)
    @acknowledgement = Acknowledgement.find_by_id(acknowledgement_id)
    if !!@acknowledgement
      @user_profile = @acknowledgement.user_profile
      @url = announcement_url(@acknowledgement.announcement, :subdomain => @acknowledgement.subdomain)
      mail(:to => @user_profile.email, :subject => "Crumblin - New #{@acknowledgement.community_name} Announcement") do |format|
         format.html { render "mailers/new_announcement" }
      end
    end
  end
end