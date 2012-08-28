###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for sent messages.
###
class SentMessagesController < MailboxController
  respond_to :html, :js
  layout 'messaging'
###
# Callbacks
###
  before_filter :block_unauthorized_user!

  # GET /mail/sent(.:format)
  def index
    @messages = current_user.sent_messages.sort_by!{|m| m.created_at}.reverse!
    @mailbox_view_state = 'sent'
    respond_with(@messages)
  end

  # GET /mail/sent/:id(.:format)
  def show
    @message = current_user.sent_messages.find(params[:id])
    authorize!(:read, @message)
    @mailbox_view_state = 'sent'
    respond_to do |format|
      format.html { render :show }
      format.js {
        render partial: 'messages/message', locals: { message: @message }
      }
    end
  end

  # GET /mail/compose(.:format)
  def new
    to = [((params[:id] && current_user.address_book.collect{ |p| p.id.to_s }.flatten.include?(params[:id])) ? params[:id] : -1)]
    @message = current_user.sent_messages.build(to: to)
    authorize!(:create, @message)
    @mailbox_view_state = 'compose'
    respond_with(@message)
  end

  # POST /sent(.:format)
  def create
    @message = current_user.sent_messages.build(params[:message])
    authorize!(:create, @message)
    if @message.save
      add_new_flash_message("Your message has been sent.",'success')
      redirect_to inbox_path
    else
      if @message.to.blank?
        errors = Array.new
        @message.errors.each{|attr,msg| errors << {attr: attr, msg: msg}}
        @message = current_user.sent_messages.build(to: [-1])
        errors.each{ |error| @message.errors.add(error[:attr],error[:msg]) }
      end
      render 'new'
    end
  end

  # GET /sent/autocomplete(.:format)
  def autocomplete
    @user_profiles = UserProfile.active.search params[:term]
    @character_proxies = CharacterProxy.search params[:term]
    render json:
      @user_profiles.map{|up| {
        id: up.id,
        label: up.display_name,
        value: up.id,
        url: user_profile_url(up),
        avatar: view_context.image_path(up.avatar_url(:icon))
      }} +
      @character_proxies.map{|cp| {
        id: cp.id,
        label: cp.name,
        value: cp.user_profile_id,
        url: user_profile_url(cp.user_profile),
        avatar: view_context.image_path(cp.avatar_url(:icon))
      }}
  end

end