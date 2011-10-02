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
    render :action => 'show'
  end

  # GET /mail/trash(.:format)
  def trash
    @folder = current_user.trash
    authorize!(:read, @folder)
    render :action => 'show'
  end

#   def show
#     @folder ||= current_user.folders.find(params[:id])
#     @messages = @folder.messages.delete_if {|message| message.deleted == true}
#   end
end
