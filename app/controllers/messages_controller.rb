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
  before_filter :load_original_message, :setup_message_body, :only => [:reply, :reply_all, :forward]
  authorize_resource :only => [:show, :mark_read, :mark_unread]

  # GET /mail/inbox/:id(.:format)
  def show
    authorize!(:read, @message.folder)
    gather_inbox_data @message.folder
    @mailbox_view_state = @message.folder.name.downcase
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
    redirect_to previous_page
  end

  # PUT /mail/:id/batch_move/:folder_id(.:format)
  def batch_move
    if params[:ids]
      folder = current_user.folders.find_by_id(params[:folder_id])
      authorize!(:update, folder)
      params[:ids].each do |id|
        @message = current_user.received_messages.find_by_id(id[0])
        authorize!(:update, @message)
        @message.update_attributes(:folder_id => folder.id, :has_been_read => (folder == current_user.trash ? true : false))
      end
    end
    redirect_to inbox_path
  end

  # PUT mail/batch_mark_read/:folder_id
  def batch_mark_read
    if params[:ids]
      params[:ids].each do |id|
        @message = current_user.received_messages.find_by_id(id[0])
        authorize!(:update, @message)
        @message.update_attributes(:has_been_read => true)
      end
    end
    redirect_to inbox_path
  end

  # PUT mail/batch_mark_unread/:folder_id
  def batch_mark_unread
    if params[:ids]
      params[:ids].each do |id|
        @message = current_user.received_messages.find_by_id(id[0])
        authorize!(:update, @message)
        @message.update_attributes(:has_been_read => false)
      end
    end
    redirect_to inbox_path
  end

  # GET /mail/reply/:id(.:format)
  def reply
    if @original.author == current_user.user_profile
      redirect_to inbox_path
    else
      subject = "Re: #{@original.subject}"
      @message = current_user.sent_messages.build(:to => [@original.author.id.to_s], :subject => subject, :body => @body)
      authorize!(:create, @message)
      render 'sent_messages/new'
    end
  end

  # GET /mail/reply-all/:id(.:format)
  def reply_all
    if @original.author == current_user.user_profile
      redirect_to inbox_path
    else
      recipients = @original.recipients.map(&:id) - [current_user.id] + [@original.author.id]
      subject = "Re: #{@original.subject}"
      @message = current_user.sent_messages.build(:to => recipients.collect{|r| r.to_s}, :subject => subject, :body => @body)
      authorize!(:create, @message)
      render 'sent_messages/new'
    end
  end

  # GET /mail/forward/:id(.:format)
  def forward
    subject = "Fwd: #{@original.subject.gsub(/^Fwd:\s*/i, '')}"
    @message = current_user.sent_messages.build(:to => [-1], :subject => subject, :body => @body)
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
    if params[:ids]
      params[:ids].each do |id|
        @message = current_user.received_messages.find_by_id(id[0])
        authorize!(:update, @message)
        @message.update_attributes(:deleted => true, :folder_id => nil, :has_been_read => true)
      end
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
    @original = Message.find(params[:id])
    return @original if can? :read, @original
    @original = current_user.received_messages.find_by_message_id(@original.id) if current_user
    redirect_to inbox_path unless can? :read, @original
  end

  ###
  # _before_filter_
  #
  # This before filter prepends text to the original message body
  ###
  def setup_message_body
    @body = "\n\n\u2014Original Message\u2014\n\n#{@original.body}"
  end

end
