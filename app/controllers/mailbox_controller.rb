###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for mailbox. It gives simple paths to the users inbox and trash.
###
class MailboxController < ApplicationController
  respond_to :html
###
# Callbacks
###
  before_filter :authenticate_user!

  # GET /mail/inbox(.:format)
  def inbox
    @folder = current_user.inbox
    authorize!(:read, @folder)
    @todays_messages = @folder.messages.joins{message}.where{(message.created_at >= Time.now.beginning_of_day.to_date)}
    @older_messages = @folder.messages.joins{message}.where{(message.created_at Time.now.beginning_of_day.to_date)}
    render 'show'
  end

  # GET /mail/trash(.:format)
  def trash
    @folder = current_user.trash
    @messages = @folder.messages
    authorize!(:read, @folder)
    render 'show'
  end
end
