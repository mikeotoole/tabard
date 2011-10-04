###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for messages. It handles the users interaction with received messages.
###
class MessagesController < ApplicationController
  respond_to :html
###
# Callbacks
###
  before_filter :authenticate_user!

  # GET /mail/inbox/:id(.:format)
  def show
    @message = current_user.received_messages.find(params[:id])
    authorize!(:read, @message)
  end
  
  # PUT /mail/:id/move/:folder_id(.:format) 
  def move
    folder = current_user.folders.find_by_id(params[:folder_id])
    # TODO Mike, Test what happens when this is nil.
    authorize!(:update, folder)
    @message = current_user.received_messages.find_by_id(params[:id])
    authorize!(:update, @message)
    add_new_flash_message('Message was moved to #{folder.name}.') if @message.update_attributes(:folder => folder)
    redirect_to previous_page
  end

  # GET /mail/reply/:id(.:format)
  def reply
    @original = current_user.received_messages.find(params[:id])

    subject = @original.subject.sub(/^(Re: )?/, "Re: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:to => [@original.author.id.to_s], :subject => subject, :body => body)
    authorize!(:create, @message)
    render :template => "sent_messages/new"
  end

  # GET /mail/reply-all/:id(.:format)
  def reply_all
    @original = current_user.received_messages.find(params[:id])

    subject = @original.subject.sub(/^(Re: )?/, "Re: ")
    body = @original.body.gsub(/^/, "> ")
    recipients = @original.recipients.map(&:id) - [current_user.id] + [@original.author.id]
    @message = current_user.sent_messages.build(:to => recipients.collect{|r| r.to_s}, :subject => subject, :body => body)
    authorize!(:create, @message)
    render :template => "sent_messages/new"
  end

  # GET /mail/forward/:id(.:format) 
  def forward
    @original = current_user.received_messages.find(params[:id])

    subject = @original.subject.sub(/^(Fwd: )?/, "Fwd: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:to => [-1], :subject => subject, :body => body)
    authorize!(:create, @message)
    render :template => "sent_messages/new"
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

end
