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
      if message_association.recipient.is_email_on_message
        MessageAssociationObserver.delay.send_email(message_association.id)
      end
    end
  end
  
  # This method is used to send the message. It is built to be used with delay.
  def self.send_email(message_association_id)
    MessageAssociationMailer.new_message(message_association_id).deliver
  end
end
