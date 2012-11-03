###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the SupportComment to send emails.
###
class SupportCommentMailer < ActionMailer::Base
  default from: "Tabard <noreply@#{ENV['BV_HOST_DOMAIN']}>",
          content_type: "text/html"
  layout 'mailer'

  # Tell user they have a new message
  def new_support_comment(support_comment_id)
    @support_comment = SupportComment.find_by_id(support_comment_id)
    if !!@support_comment
      @user_profile = @support_comment.user_profile
      @support_ticket = @support_comment.support_ticket
      @url = admin_support_ticket_url(@support_ticket)
      mail(to: @support_comment.support_ticket_admin_user_email, subject: "Tabard: Updated Support Ticket") do |format|
         format.html { render "mailers/new_support_comment" }
      end
    end
  end
end
