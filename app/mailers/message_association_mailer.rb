###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used by the MessageAssociationObserver to send emails.
###
class MessageAssociationMailer < ActionMailer::Base
  default :from => "Crumblin <noreply@crumblin.com>",
          :content_type => "text/html"
  layout 'mailer'
  
  # Tell user they have a new message
  def new_message(message_association_id)
    @message_association = MessageAssociation.find_by_id(message_association_id)
    if !!@message_association
      @subject = @message_association.is_system_sent ? "Crumblin - #{@message_association.subject}" : "Crumblin - New Message From #{@message_association.author_name}"
      @user_profile = @message_association.recipient
      mail(:to => @user_profile.email, :subject => @subject) do |format|
         format.html { render "mailers/new_message" }
      end
    end
  end
end