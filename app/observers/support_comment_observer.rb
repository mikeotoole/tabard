###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for SupportComment.
###
class SupportCommentObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers

  # Notifies support with an email
  def after_create(support_comment)
    unless Rails.env.test?
      if support_comment.user_profile.blank?
        default_url_options[:host] = ENV["RAILS_ENV"] == 'production' ? "brutalvenom.com" : "lvh.me:3000"
        message = Message.create_system(:subject => "Support ticket update",
                  :body => "#{support_comment.admin_user_display_name} has made a new comment on your support ticket ##{support_comment.support_ticket_id}. [View Support Ticket](#{support_url(support_comment.support_ticket)})",
                  :to => [support_comment.support_ticket_user_profile_id])
      else
        SupportCommentObserver.delay.send_support_email(support_comment.id)
      end
    end
  end

  def self.send_support_email(support_comment_id)
    SupportCommentMailer.new_support_comment(support_comment_id).deliver
  end
end
