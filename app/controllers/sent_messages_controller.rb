###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for sent messages.
###
class SentMessagesController < ApplicationController
  respond_to :html
  layout 'messaging'
###
# Callbacks
###
  before_filter :authenticate_user!

  # GET /mail/sent(.:format)
  def index
    @messages = current_user.sent_messages
    respond_with(@messages)
  end

  # GET /mail/sent/:id(.:format)
  def show
    @message = current_user.sent_messages.find(params[:id])
    authorize!(:read, @message)
    respond_with(@message)
  end

  # GET /mail/compose(.:format)
  def new
    @message = current_user.sent_messages.build(:to => [-1])
    authorize!(:create, @message)
    respond_with(@message)
  end

  # POST /sent(.:format)
  def create
    @message = current_user.sent_messages.build(params[:message])
    authorize!(:create, @message)
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
      render 'new'
    end
  end

end
