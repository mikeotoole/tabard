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
      SupportTicketMailer.delay.new_support_ticket(support_ticket.id)
    end
  end
end
