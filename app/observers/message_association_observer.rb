###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for MessageAssociation.
###
class MessageAssociationObserver < ActiveRecord::Observer
  ###
  # Notify user of new message if they have that option set.
  ###
  def after_create(message_association)
    unless Rails.env.test?
      if message_association.recipient.is_email_on_message and not message_association.dont_send_email
        MessageAssociationMailer.delay.new_message(message_association.id)
      end
    end
  end
end
