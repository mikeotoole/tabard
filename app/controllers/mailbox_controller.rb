class MailboxController < ApplicationController
  before_filter :authenticate  
  respond_to :html
  
  def index
    @folder = current_user.inbox
    render :action => 'show'
  end

  def show
    @folder ||= current_user.folders.find(params[:id])
    @messages = @folder.messages.delete_if {|message| message.deleted == true}
  end

  def trash
    @folder = Struct.new(:name, :user_profile_id).new("Trash", current_user.user_profile.id)
    @messages = current_user.deleted_received_messages
    render :action => 'show'
  end

end