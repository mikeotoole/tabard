###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for SupportTicket.
###
class SupportTicketObserver < ActiveRecord::Observer

  # Notifies support with an email
  def after_create(support_ticket)
    unless Rails.env.test?
      SupportTicketObserver.delay.send_support_email(support_ticket.id)
    end
  end

  # Sends the email
  def self.send_support_email(support_ticket_id)
    SupportTicketMailer.new_support_ticket(support_ticket_id).deliver
  end
end
