###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for messages. It handles the users interaction with received messages.
###
class MessagesController < MailboxController
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
    authorize!(:read, @message.folder)
    gather_inbox_data @message.folder
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
    if @message.update_attributes(:folder_id => folder.id, :has_been_read => (folder == current_user.trash ? true : false))
      add_new_flash_message('Message was moved to #{folder.name}.')
    end
    redirect_to @message
  end

  # PUT /mail/:id/batch_move/:folder_id(.:format)
  def batch_move
    folder = current_user.folders.find_by_id(params[:folder_id])
    authorize!(:update, folder)
    params[:ids].each do |id|
      @message = current_user.received_messages.find_by_id(id[0])
      authorize!(:update, @message)
      @message.update_attributes(:folder_id => folder.id, :has_been_read => (folder == current_user.trash ? true : false))
    end
    redirect_to inbox_path
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
      if @message.update_attributes(:deleted => true, :folder_id => nil, :has_been_read => true)
        add_new_flash_message('Message was deleted.')
      end
      redirect_to trash_path
    else # If a message is not given all messages will be deleted from the trash.
      current_user.trash.messages.each do |message|
        authorize!(:update, message)
        message.update_attributes(:deleted => true, :folder_id => nil, :has_been_read => true)
      end
      redirect_to inbox_path
    end
  end

  # DELETE /mail/batch_delete/:id(.:format)
  def batch_destroy
    params[:ids].each do |id|
      @message = current_user.received_messages.find(id[0])
      authorize!(:update, @message)
      @message.update_attributes(:deleted => true, :folder_id => nil, :has_been_read => true)
    end
    redirect_to trash_path
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
