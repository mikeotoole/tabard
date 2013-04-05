###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for SupportComment.
###
class SupportCommentObserver < ActiveRecord::Observer
  # Notifies support with an email
  def after_create(support_comment)
    unless Rails.env.test?
      if support_comment.user_profile.blank?
        default_url_options[:host] = ENV['BV_HOST_URL']
        message = Message.create_system(subject: "Support ticket update",
                  body: "#{support_comment.admin_user_display_name} has made a new comment on your support ticket ##{support_comment.support_ticket_id}. [View Support Ticket](#{url_helpers.support_url(support_comment.support_ticket, anchor: "comment_#{support_comment.id}")})",
                  to: [support_comment.support_ticket_user_profile_id])
      else
        SupportCommentObserver.delay.send_support_email(support_comment.id)
      end
    end
  end

  # Sends the support email
  def self.send_support_email(support_comment_id)
    SupportCommentMailer.new_support_comment(support_comment_id).deliver
  end

protected

  # Allows us to use url helpers in model without messing up the namespace.
  def url_helpers
    Rails.application.routes.url_helpers
  end
end
