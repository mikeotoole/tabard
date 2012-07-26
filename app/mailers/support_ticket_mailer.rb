###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the SupportTicket to send emails.
###
class SupportTicketMailer < ActionMailer::Base
  default from: "Guild.io <noreply@guild.io>",
          content_type: "text/html"
  layout 'mailer'

  # Tell user they have a new message
  def new_support_ticket(support_ticket_id)
    @support_ticket = SupportTicket.find_by_id(support_ticket_id)
    if !!@support_ticket
      @user_profile = @support_ticket.user_profile
      @url = admin_support_ticket_url(@support_ticket)
      mail(to: "support@guild.io", subject: "Guild.io - New Support Ticket") do |format|
         format.html { render "mailers/new_support_ticket" }
      end
    end
  end
end