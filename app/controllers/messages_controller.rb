###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for messages. It handles the users interaction with received messages.
###
class MessagesController < ApplicationController
  respond_to :html
  layout 'messaging'
###
# Callbacks
###
  before_filter :authenticate_user!
  before_filter :load_message, :only => [:show, :mark_read, :mark_unread]
  before_filter :load_original_message, :only => [:reply, :reply_all, :forward]
  before_filter :setup_subject_and_body, :only => [:reply, :reply_all]
  authorize_resource :only => [:show, :mark_read, :mark_unread]

  # GET /mail/inbox/:id(.:format)
  def show
    @message.update_attributes(:has_been_read => true)
  end
  
  # POST /mail/mark_read/:id(.:format)
  def mark_read
    @message.update_attributes(:has_been_read => true)
    redirect_to previous_page
  end
  
  # POST /mail/mark_unread/:id(.:format)
  def mark_unread
    @message.update_attributes(:has_been_read => false)
    redirect_to previous_page
  end

  # PUT /mail/:id/move/:folder_id(.:format)
  def move
    folder = current_user.folders.find_by_id(params[:folder_id])
    authorize!(:update, folder)
    @message = current_user.received_messages.find_by_id(params[:id])
    authorize!(:update, @message)
    add_new_flash_message('Message was moved to #{folder.name}.') if @message.update_attributes(:folder => folder)
    redirect_to previous_page
  end

  # GET /mail/reply/:id(.:format)
  def reply
    @message = current_user.sent_messages.build(:to => [@original.author.id.to_s], :subject => @subject, :body => @body)
    authorize!(:create, @message)
    render 'sent_messages/new'
  end

  # GET /mail/reply-all/:id(.:format)
  def reply_all
    recipients = @original.recipients.map(&:id) - [current_user.id] + [@original.author.id]
    @message = current_user.sent_messages.build(:to => recipients.collect{|r| r.to_s}, :subject => @subject, :body => @body)
    authorize!(:create, @message)
    render 'sent_messages/new'
  end

  # GET /mail/forward/:id(.:format)
  def forward
    subject = @original.subject.sub(/^(Fwd: )?/, "Fwd: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:to => [-1], :subject => subject, :body => body)
    authorize!(:create, @message)
    render 'sent_messages/new'
  end

  # DELETE /mail/delete/:id(.:format)
  def destroy
    if(params[:id])
      @message = current_user.received_messages.find(params[:id])
      authorize!(:update, @message)
      add_new_flash_message('Message was deleted.') if @message.update_attributes(:deleted => true, :folder_id => nil)
      redirect_to trash_path
    else # If a message is not given all messages will be deleted from the trash.
      current_user.trash.messages.each do |message|
        authorize!(:update, message)
        message.update_attributes(:deleted => true, :folder_id => nil)
      end
      redirect_to inbox_path
    end
  end

###
# Protected Methods
###
protected

  ###
  # _before_filter_
  #
  # This before filter loads the message from the id params.
  ###
  def load_message
    @message = current_user.received_messages.find(params[:id]) if current_user
  end

  ###
  # _before_filter_
  #
  # This before filter loads the message from the id params.
  ###
  def load_original_message
    @original = current_user.received_messages.find(params[:id]) if current_user
  end

  ###
  # _before_filter_
  #
  # This before filter prepends the "Re" tag to subject and comments body.
  ###
  def setup_subject_and_body
    @subject = @original.subject.sub(/^(Re: )?/, "Re: ")
    @body = @original.body.gsub(/^/, "> ")
  end

end
