class SentController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml  
  
  def index
    @messages = current_user.sent_messages
    
    respond_with(@messages)
  end

  def show
    @message = current_user.sent_messages.find(params[:id])

    respond_with(@message)
  end

  def new
    @message = current_user.sent_messages.build(:to => [-1])
    
    respond_with(@message)    
  end
  
  def create
    @message = current_user.sent_messages.build(params[:message])
    
    if @message.save
      flash[:notice] = "Message sent."
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
end
