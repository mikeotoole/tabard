class MessagesController < ApplicationController
  def show
    @message = current_user.received_messages.find(params[:id])
  end
  
  def reply
    @original = current_user.received_messages.find(params[:id])
    
    subject = @original.subject.sub(/^(Re: )?/, "Re: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:to => [@original.author.id.to_s], :subject => subject, :body => body)
    render :template => "sent/new"
  end
  
  def forward
    @original = current_user.received_messages.find(params[:id])
    
    subject = @original.subject.sub(/^(Fwd: )?/, "Fwd: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:to => [-1], :subject => subject, :body => body)
    render :template => "sent/new"
  end
  
  def reply_all
    @original = current_user.received_messages.find(params[:id])
    
    subject = @original.subject.sub(/^(Re: )?/, "Re: ")
    body = @original.body.gsub(/^/, "> ")
    recipients = @original.recipients.map(&:id) - [current_user.id] + [@original.author.id] 
    @message = current_user.sent_messages.build(:to => recipients.collect{|r| r.to_s}, :subject => subject, :body => body)
    render :template => "sent/new"
  end  
    
  def destroy
    @message = current_user.received_messages.find(params[:id])
    if @message.update_attribute("deleted", true)
      add_new_flash_message('Message was moved to your trash.')
    end
    redirect_to inbox_path
  end
  
  def undelete
    @message = current_user.received_messages.find(params[:id])
    if @message.update_attribute("deleted", false)
      add_new_flash_message('Message was restored to your inbox.')
    end
    redirect_to inbox_path
  end    
    
end
