=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is for sent messages.
=end
class SentController < ApplicationController
  respond_to :html
  before_filter :authenticate
  
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
      add_new_flash_message("Your message has been sent.")
      redirect_to :action => "index"
    else
      if @message.to.blank?
        errors = Array.new
        @message.errors.each{|attr,msg| errors << {:attr => attr, :msg => msg}}
        @message = current_user.sent_messages.build(:to => [-1])
        errors.each{ |error| @message.errors.add(error[:attr],error[:msg]) }
      end
      grab_all_errors_from_model(@message) 
      render :action => "new"
    end
  end
  
end
