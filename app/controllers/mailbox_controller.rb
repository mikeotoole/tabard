###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for mailbox. It gives simple paths to the users inbox and trash.
###
class MailboxController < ApplicationController
  respond_to :html
  layout 'messaging'

###
# Callbacks
###
  before_filter :authenticate_user!

  # GET /mail/inbox(.:format)
  def inbox
    @folder = current_user.inbox
    authorize!(:read, @folder)
    gather_inbox_data @folder
    @mailbox_view_state = 'inbox'
    render 'show'
  end

  # GET /mail/trash(.:format)
  def trash
    @folder = current_user.trash
    authorize!(:read, @folder)
    gather_inbox_data @folder
    @mailbox_view_state = 'trash'
    render 'show'
  end

###
# Protected Methods
###
protected

  # This method loads the messages for a given folder, grouped by today's messages and all older messages
  def gather_inbox_data(folder)
    @todays_messages = folder.messages.joins{message}.where{(message.created_at >= Time.now.beginning_of_day)}
    @older_messages = folder.messages.joins{message}.where{(message.created_at < Time.now.beginning_of_day)}
  end
  
  # This method will determine a string value for the current view in the mailbox
  def mailbox_view_state
    @mailbox_view_state ||= ''
  end
  helper_method :mailbox_view_state
  
end
