###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for Acknowledgement.
###
class AcknowledgementObserver < ActiveRecord::Observer
  ###
  # Notify user of new message if they have that option set.
  ###
  def after_create(acknowledgement)
    unless Rails.env.test?
      if acknowledgement.community_profile.is_email_on_announcement and not acknowledgement.has_been_viewed
        AcknowledgementObserver.delay.send_acknowledgement_email(acknowledgement.id)
      end
    end
  end
  
  # This method is used to send the message. It is built to be used with delay.
  def self.send_acknowledgement_email(acknowledgement_id)
    AcknowledgementMailer.new_acknowledgement(acknowledgement_id).deliver
  end
end
